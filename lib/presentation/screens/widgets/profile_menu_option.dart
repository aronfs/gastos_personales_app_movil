import 'package:flutter/material.dart';

/// Representa una opción de la lista de menú del perfil
/// (ej. "Información personal", "Métodos de pago").
class ProfileMenuOption {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuOption({
    required this.icon,
    required this.title,
    this.onTap,
  });
}
