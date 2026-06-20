import 'package:flutter/material.dart';

/// Encabezado de sección en mayúsculas usado para agrupar settings
/// (ej. "APARIENCIA", "CUENTA", "SESIONES ACTIVAS").
class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9A9DB0),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
