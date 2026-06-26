import 'package:flutter/material.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_group_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_section_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_switch_row.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushEnabled = true;
  bool _emailEnabled = true;
  bool _smsEnabled = false;
  bool _paymentReminders = true;
  bool _weeklySummary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SettingsAppBar(title: 'Notificaciones'),
            const SizedBox(height: 16),
            const SettingsSectionHeader(title: 'Canales'),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.notifications_none,
                  title: 'Push',
                  subtitle: 'Notificaciones en el dispositivo',
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.mail_outline,
                  title: 'Email',
                  subtitle: 'Notificaciones al correo',
                  value: _emailEnabled,
                  onChanged: (v) => setState(() => _emailEnabled = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.sms_outlined,
                  title: 'SMS',
                  subtitle: 'Notificaciones por mensaje de texto',
                  value: _smsEnabled,
                  onChanged: (v) => setState(() => _smsEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SettingsSectionHeader(title: 'Alertas'),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.payment_outlined,
                  title: 'Recordatorios de pago',
                  subtitle: 'Antes de la fecha de vencimiento',
                  value: _paymentReminders,
                  onChanged: (v) => setState(() => _paymentReminders = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.assessment_outlined,
                  title: 'Resumen semanal',
                  subtitle: 'Cada lunes recibirás un resumen',
                  value: _weeklySummary,
                  onChanged: (v) => setState(() => _weeklySummary = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
