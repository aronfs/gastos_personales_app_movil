import 'package:flutter/material.dart';

/// Encabezado de sección con etiqueta a la izquierda (ej. "PRODUCTOS")
/// y un botón tipo pill a la derecha (ej. "+ Agregar").
class SectionHeaderWithAction extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeaderWithAction({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9A9DB0),
            letterSpacing: 0.4,
          ),
        ),
        if (actionLabel != null)
          Material(
            color: const Color(0xFFEDEEF3),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onActionTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2962FF),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
