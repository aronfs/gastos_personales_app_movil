import 'package:flutter/material.dart';

/// Card de resumen con fondo en degradado: etiqueta pequeña, monto
/// grande y una línea de variación (ej. "+12% vs mes anterior").
class GradientSummaryCard extends StatelessWidget {
  final String label;
  final String amountLabel;
  final String? deltaLabel;
  final List<Color> gradientColors;

  const GradientSummaryCard({
    super.key,
    required this.label,
    required this.amountLabel,
    this.deltaLabel,
    this.gradientColors = const [Color(0xFF34C759), Color(0xFF1FAE6E)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            amountLabel,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          if (deltaLabel != null) ...[
            const SizedBox(height: 6),
            Text(
              deltaLabel!,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
