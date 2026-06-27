import 'package:flutter/material.dart';
import 'package:gastos_personales/data/repositories/auth_repository.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/screens/change_password_page.dart';
import 'package:gastos_personales/presentation/screens/widgets/active_session_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/destructive_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_group_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_navigation_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_section_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_switch_row.dart';
import 'package:gastos_personales/util/biometric_service.dart';
import 'package:gastos_personales/util/token_storage.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _biometricAccess = false;
  bool _smsTwoFactor = false;
  bool _loadingBiometric = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    final enabled = await TokenStorage.isBiometricEnabled();
    if (mounted) {
      setState(() {
        _biometricAccess = enabled;
        _loadingBiometric = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      try {
        final authRepo = AuthRepository();
        await authRepo.enableBiometric();
        if (mounted) setState(() => _biometricAccess = true);
      } catch (e) {
        if (!mounted) return;
        if (e is BiometricException &&
            (e.code == 'NotAvailable' || e.code == 'NotEnrolled')) {
          await _showEnrollBiometricDialog(context);
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
          );
      }
    } else {
      await TokenStorage.setBiometricEnabled(false);
      if (mounted) setState(() => _biometricAccess = false);
    }
  }

  Future<void> _showEnrollBiometricDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.fingerprintNotRegisteredTitle),
        content: Text(loc.fingerprintNotRegisteredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.goToSettings),
          ),
        ],
      ),
    );
    if (goToSettings == true && mounted) {
      await BiometricService.openBiometricSettings();
    }
  }

  void _handleCloseAllSessions() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(loc.closeAllSessionsTitle),
        content: Text(loc.closeAllSessionsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.sessionsClosed)),
              );
            },
            child: Text(loc.closeAll, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SettingsAppBar(title: loc.securityTitle),
            const SizedBox(height: 16),
            SettingsSectionHeader(title: loc.accountSection),
            SettingsGroupCard(
              rows: [
                SettingsNavigationRow(
                  icon: Icons.lock_outline,
                  title: loc.changePassword,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                  ),
                ),
                SettingsSwitchRow(
                  icon: Icons.fingerprint,
                  title: loc.biometricAccess,
                  value: _biometricAccess,
                  onChanged: _loadingBiometric
                      ? (_) {}
                      : (v) {
                          _toggleBiometric(v);
                        },
                ),
                SettingsSwitchRow(
                  icon: Icons.shield_outlined,
                  title: loc.sms2FA,
                  value: _smsTwoFactor,
                  onChanged: (v) => setState(() => _smsTwoFactor = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSectionHeader(title: loc.activeSessions),
            SettingsGroupCard(
              rows: [
                ActiveSessionRow(
                  icon: Icons.phone_iphone,
                  deviceName: 'iPhone 15 Pro',
                  locationInfo: 'Lima · Activo ahora',
                  badgeLabel: loc.currentSession,
                ),
                ActiveSessionRow(
                  icon: Icons.language,
                  deviceName: 'Chrome — Mac',
                  locationInfo: 'Lima · Hace 2h',
                ),
              ],
            ),
            const SizedBox(height: 20),
            DestructiveActionButton(
              label: loc.closeAllSessions,
              onPressed: _handleCloseAllSessions,
            ),
          ],
        ),
      ),
    );
  }
}
