import 'package:flutter/material.dart';

/// Avatar circular grande con fondo de color sólido e icono blanco,
/// usado como cabecera visual de formularios de creación
/// (ej. "Nuevo producto").
class IconCircleAvatar extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final String? caption;

  const IconCircleAvatar({
    super.key,
    required this.icon,
    this.backgroundColor = const Color(0xFF2962FF),
    this.iconColor = Colors.white,
    this.size = 72,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: size * 0.42, color: iconColor),
        ),
        if (caption != null) ...[
          const SizedBox(height: 12),
          Text(
            caption!.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9A9DB0),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
