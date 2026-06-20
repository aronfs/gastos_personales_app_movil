import 'package:flutter/material.dart';

/// Pequeño indicador de leyenda: círculo de color + etiqueta.
class LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final double dotSize;
  final TextStyle? textStyle;

  const LegendDot({
    super.key,
    required this.color,
    required this.label,
    this.dotSize = 10,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotSize,
          height: dotSize,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: textStyle ??
              const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B6E80),
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
