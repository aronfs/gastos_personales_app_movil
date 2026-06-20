import 'package:flutter/material.dart';

/// Campo inline compacto: icono a la izquierda y texto editable,
/// usado para PRECIO UNITARIO y CATEGORÍA en dos columnas.
class InlineInputField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final VoidCallback? onTap;
  final bool isReadOnly;

  const InlineInputField({
    super.key,
    required this.icon,
    required this.value,
    this.iconColor = const Color(0xFF9A9DB0),
    this.onTap,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFEEF0F4), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
