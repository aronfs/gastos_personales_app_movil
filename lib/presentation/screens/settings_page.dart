import 'package:flutter/material.dart';
import 'package:gastos_personales/main.dart' show themeNotifier;
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_group_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_navigation_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_section_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_switch_row.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _weeklyEmailSummary = false;

  String _language = 'Español';
  String _currency = 'USD — \$';

  static const _languages = ['Español', 'English'];
  static const _currencies = ['USD — \$', 'EUR — €', 'PEN — S/.', 'MXN — \$'];

  void _showLanguagePicker() {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.languagePickerTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            ..._languages.map((lang) => ListTile(
              leading: Icon(
                lang == _language ? Icons.radio_button_checked : Icons.radio_button_off,
                color: cs.primary,
              ),
              title: Text(lang),
              onTap: () {
                setState(() => _language = lang);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    final loc = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.currencyPickerTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            ..._currencies.map((cur) => ListTile(
              leading: Icon(
                cur == _currency ? Icons.radio_button_checked : Icons.radio_button_off,
                color: cs.primary,
              ),
              title: Text(cur),
              onTap: () {
                setState(() => _currency = cur);
                Navigator.pop(context);
              },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            SettingsSectionHeader(title: loc.appearance),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.dark_mode_outlined,
                  title: loc.darkMode,
                  value: themeNotifier.value == ThemeMode.dark,
                  onChanged: (v) => themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light,
                ),
                SettingsNavigationRow(
                  icon: Icons.language,
                  title: loc.language,
                  value: _language,
                  onTap: _showLanguagePicker,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSectionHeader(title: loc.preferences),
            SettingsGroupCard(
              rows: [
                SettingsNavigationRow(
                  icon: Icons.credit_card_outlined,
                  title: loc.currency,
                  value: _currency,
                  onTap: _showCurrencyPicker,
                ),
                SettingsSwitchRow(
                  icon: Icons.notifications_none,
                  title: loc.pushNotifications,
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.mail_outline,
                  title: loc.weeklyEmailSummary,
                  value: _weeklyEmailSummary,
                  onChanged: (v) => setState(() => _weeklyEmailSummary = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
