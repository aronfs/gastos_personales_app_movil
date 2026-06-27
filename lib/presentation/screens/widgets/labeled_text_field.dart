import 'package:flutter/material.dart';

/// Campo de texto plano estilo "card": etiqueta en mayúsculas encima,
/// campo blanco redondeado con icono opcional a la izquierda.
class LabeledTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final String hintText;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;

  const LabeledTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.hintText = '',
    this.prefixIcon,
    this.prefixIconColor,
    this.controller,
    this.onChanged,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: cs.onSurfaceVariant,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Icon(
                    prefixIcon,
                    size: 18,
                    color: prefixIconColor ?? cs.onSurfaceVariant,
                  ),
                ),
              Expanded(
                child: TextFormField(
                  initialValue: controller == null ? initialValue : null,
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
