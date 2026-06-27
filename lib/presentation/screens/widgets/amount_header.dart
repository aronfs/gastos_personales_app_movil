import 'package:flutter/material.dart';

/// Encabezado de monto grande para formularios de "Nuevo gasto" o
/// "Nuevo ingreso": etiqueta pequeña arriba (ej. "MONTO", "INGRESO"),
/// signo opcional (+) y el monto en tipografía grande.
class AmountHeader extends StatelessWidget {
  final String label;
  final String amountText;
  final String? prefixSign;
  final Color amountColor;

  const AmountHeader({
    super.key,
    required this.label,
    required this.amountText,
    this.prefixSign,
    this.amountColor = const Color(0xFF1A1A2E),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: amountColor.withValues(alpha: 0.7),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (prefixSign != null)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  prefixSign!,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: amountColor,
                  ),
                ),
              ),
            Text(
              amountText,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: amountColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
