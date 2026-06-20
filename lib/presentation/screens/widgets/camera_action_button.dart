import 'package:flutter/material.dart';

/// Botón individual de la barra de acciones de cámara:
/// icono (con fondo activo azul si está seleccionado) y label debajo.
class CameraActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const CameraActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF2F6BFF)
                  : const Color(0xFF1E2235),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22,
              color: isActive ? Colors.white : const Color(0xFF8A8FA8),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF8A8FA8),
            ),
          ),
        ],
      ),
    );
  }
}
