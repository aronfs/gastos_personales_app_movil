import 'package:flutter/material.dart';

/// Encabezado que agrupa transacciones por fecha (ej. "HOY · 14 NOV")
/// con el total de ese día alineado a la derecha.
class DateGroupHeader extends StatelessWidget {
  final String dateLabel;
  final String totalLabel;
  final Color? totalColor;

  const DateGroupHeader({
    super.key,
    required this.dateLabel,
    required this.totalLabel,
    this.totalColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final resolvedTotalColor = totalColor ?? cs.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              dateLabel.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            totalLabel,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: resolvedTotalColor,
            ),
          ),
        ],
      ),
    );
  }
}
