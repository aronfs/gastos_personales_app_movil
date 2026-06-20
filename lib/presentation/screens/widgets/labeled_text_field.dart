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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9A9DB0),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEF0F4), width: 1),
          ),
          child: Row(
            children: [
              if (prefixIcon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Icon(
                    prefixIcon,
                    size: 18,
                    color: prefixIconColor ?? const Color(0xFF9A9DB0),
                  ),
                ),
              Expanded(
                child: TextFormField(
                  initialValue: controller == null ? initialValue : null,
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFFB7BAC6),
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
