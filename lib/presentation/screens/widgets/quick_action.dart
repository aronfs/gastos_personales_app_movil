import 'package:flutter/material.dart';

/// Representa una acción rápida del menú de acciones del FAB:
/// icono, colores, título, subtítulo y callback.
class QuickAction {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const QuickAction({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
