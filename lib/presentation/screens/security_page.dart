import 'package:flutter/material.dart';
import 'package:gastos_personales/data/repositories/auth_repository.dart';
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
    final goToSettings = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar huella digital'),
        content: const Text(
          'No hay huellas registradas en el dispositivo. '
          'Ve a Ajustes > Seguridad y registra una huella para usar esta función.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ir a Ajustes'),
          ),
        ],
      ),
    );
    if (goToSettings == true && mounted) {
      await BiometricService.openBiometricSettings();
    }
  }

  void _handleCloseAllSessions() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar todas las sesiones'),
        content: const Text(
          'Se cerrarán todas las sesiones activas, incluyendo la actual. '
          'Deberás iniciar sesión nuevamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sesiones cerradas correctamente')),
              );
            },
            child: Text('Cerrar todo', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SettingsAppBar(title: 'Seguridad'),
            const SizedBox(height: 16),
            const SettingsSectionHeader(title: 'Cuenta'),
            SettingsGroupCard(
              rows: [
                SettingsNavigationRow(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                  ),
                ),
                SettingsSwitchRow(
                  icon: Icons.fingerprint,
                  title: 'Acceso biométrico',
                  value: _biometricAccess,
                  onChanged: _loadingBiometric
                      ? (_) {}
                      : (v) {
                          _toggleBiometric(v);
                        },
                ),
                SettingsSwitchRow(
                  icon: Icons.shield_outlined,
                  title: '2FA por SMS',
                  value: _smsTwoFactor,
                  onChanged: (v) => setState(() => _smsTwoFactor = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SettingsSectionHeader(title: 'Sesiones activas'),
            const SettingsGroupCard(
              rows: [
                ActiveSessionRow(
                  icon: Icons.phone_iphone,
                  deviceName: 'iPhone 15 Pro',
                  locationInfo: 'Lima · Activo ahora',
                  badgeLabel: 'Actual',
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
              label: 'Cerrar todas las sesiones',
              onPressed: _handleCloseAllSessions,
            ),
          ],
        ),
      ),
    );
  }
}
