import 'package:flutter/material.dart';
import 'package:gastos_personales/presentation/screens/widgets/active_session_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/destructive_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_group_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_navigation_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_section_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_switch_row.dart';


class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  bool _biometricAccess = true;
  bool _smsTwoFactor = false;

  void _handleCloseAllSessions() {
    // Aquí se podría disparar la lógica para cerrar todas las sesiones,
    // ej. mostrando un diálogo de confirmación.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            SettingsAppBar(title: 'Seguridad'),
            const SizedBox(height: 16),
            const SettingsSectionHeader(title: 'Cuenta'),
            SettingsGroupCard(
              rows: [
                SettingsNavigationRow(
                  icon: Icons.lock_outline,
                  title: 'Cambiar contraseña',
                  onTap: () {},
                ),
                SettingsSwitchRow(
                  icon: Icons.fingerprint,
                  title: 'Acceso biométrico',
                  value: _biometricAccess,
                  onChanged: (v) => setState(() => _biometricAccess = v),
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
