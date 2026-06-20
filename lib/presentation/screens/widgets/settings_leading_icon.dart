import 'package:flutter/material.dart';

/// Icono dentro de un círculo gris claro, usado al inicio de cada fila
/// de configuración.
class SettingsLeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const SettingsLeadingIcon({
    super.key,
    required this.icon,
    this.backgroundColor = const Color(0xFFF2F3F7),
    this.iconColor = const Color(0xFF2A2D3A),
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: iconColor),
    );
  }
}
