import 'package:flutter/material.dart';

/// Campo inline compacto: icono a la izquierda y texto editable,
/// usado para PRECIO UNITARIO y CATEGORÍA en dos columnas.
class InlineInputField extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String value;
  final VoidCallback? onTap;
  final bool isReadOnly;

  const InlineInputField({
    super.key,
    required this.icon,
    required this.value,
    this.iconColor,
    this.onTap,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: iconColor ?? cs.onSurfaceVariant),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
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
