import 'package:flutter/material.dart';
import 'settings_leading_icon.dart';

/// Fila de configuración navegable: icono, título, valor opcional a la
/// derecha (ej. "Español", "USD — \$") y chevron. Ej: "Idioma", "Moneda".
class SettingsNavigationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  const SettingsNavigationRow({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SettingsLeadingIcon(icon: icon),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9A9DB0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              const Icon(
                Icons.chevron_right,
                size: 22,
                color: Color(0xFFB7BAC6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
