import 'package:flutter/material.dart';

/// Encabezado que agrupa transacciones por fecha (ej. "HOY · 14 NOV")
/// con el total de ese día alineado a la derecha.
class DateGroupHeader extends StatelessWidget {
  final String dateLabel;
  final String totalLabel;
  final Color totalColor;

  const DateGroupHeader({
    super.key,
    required this.dateLabel,
    required this.totalLabel,
    this.totalColor = const Color(0xFF1A1A2E),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateLabel.toUpperCase(),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9A9DB0),
              letterSpacing: 0.3,
            ),
          ),
          Text(
            totalLabel,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: totalColor,
            ),
          ),
        ],
      ),
    );
  }
}
