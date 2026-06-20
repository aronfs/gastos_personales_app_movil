import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'category_share.dart';

/// Gráfico de dona que muestra la distribución porcentual por categoría,
/// con el monto total centrado.
class CategoryDonutChart extends StatelessWidget {
  final List<CategoryShare> categories;
  final String centerLabel;
  final double size;
  final double strokeWidth;

  const CategoryDonutChart({
    super.key,
    required this.categories,
    required this.centerLabel,
    this.size = 110,
    this.strokeWidth = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(
              categories: categories,
              strokeWidth: strokeWidth,
            ),
          ),
          Text(
            centerLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<CategoryShare> categories;
  final double strokeWidth;

  _DonutPainter({required this.categories, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double total =
        categories.fold<double>(0, (sum, c) => sum + c.percentage);
    if (total <= 0) return;

    final Rect rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    double startAngle = -math.pi / 2;
    const double gapRadians = 0.045;

    for (final category in categories) {
      final double sweep = (category.percentage / total) * 2 * math.pi;
      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        rect,
        startAngle + gapRadians / 2,
        sweep - gapRadians,
        false,
        paint,
      );

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.categories != categories ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
