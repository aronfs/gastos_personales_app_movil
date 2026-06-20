import 'package:flutter/material.dart';

/// Botón destructivo de ancho completo, fondo rojo claro y texto rojo.
/// Ej: "Cerrar todas las sesiones".
class DestructiveActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const DestructiveActionButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFCE7E7),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE05757),
            ),
          ),
        ),
      ),
    );
  }
}
