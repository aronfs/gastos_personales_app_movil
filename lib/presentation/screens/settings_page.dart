import 'package:flutter/material.dart';
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
  bool _darkTheme = true;
  bool _pushNotifications = true;
  bool _weeklyEmailSummary = false;

  String _language = 'Español';
  String _currency = 'USD — \$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const SettingsSectionHeader(title: 'Apariencia'),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Tema oscuro',
                  value: _darkTheme,
                  onChanged: (v) => setState(() => _darkTheme = v),
                ),
                SettingsNavigationRow(
                  icon: Icons.language,
                  title: 'Idioma',
                  value: _language,
                  onTap: () {
                    // Aquí se podría abrir un selector de idioma.
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SettingsSectionHeader(title: 'Preferencias'),
            SettingsGroupCard(
              rows: [
                SettingsNavigationRow(
                  icon: Icons.credit_card_outlined,
                  title: 'Moneda',
                  value: _currency,
                  onTap: () {
                    // Aquí se podría abrir un selector de moneda.
                  },
                ),
                SettingsSwitchRow(
                  icon: Icons.notifications_none,
                  title: 'Notificaciones push',
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.mail_outline,
                  title: 'Resumen semanal\npor email',
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
