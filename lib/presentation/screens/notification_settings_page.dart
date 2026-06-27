import 'package:flutter/material.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SettingsAppBar(title: loc.notificationSettings),
            const SizedBox(height: 16),
            SettingsSectionHeader(title: loc.channelsSection),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.notifications_none,
                  title: loc.pushChannel,
                  subtitle: loc.pushSubtitle,
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.mail_outline,
                  title: loc.emailChannel,
                  subtitle: loc.emailSubtitle,
                  value: _emailEnabled,
                  onChanged: (v) => setState(() => _emailEnabled = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.sms_outlined,
                  title: loc.smsChannel,
                  subtitle: loc.smsSubtitle,
                  value: _smsEnabled,
                  onChanged: (v) => setState(() => _smsEnabled = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSectionHeader(title: loc.alertsSection),
            SettingsGroupCard(
              rows: [
                SettingsSwitchRow(
                  icon: Icons.payment_outlined,
                  title: loc.paymentReminders,
                  subtitle: loc.paymentRemindersSubtitle,
                  value: _paymentReminders,
                  onChanged: (v) => setState(() => _paymentReminders = v),
                ),
                SettingsSwitchRow(
                  icon: Icons.assessment_outlined,
                  title: loc.weeklySummaryTitle,
                  subtitle: loc.weeklySummarySubtitle,
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
