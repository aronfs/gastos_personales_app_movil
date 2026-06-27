import 'package:flutter/material.dart';
import 'income_expense_point.dart';

/// Gráfico de barras agrupadas (ingresos vs gastos) dibujado con CustomPaint,
/// sin dependencias externas.
class IncomeExpenseBarChart extends StatelessWidget {
  final List<IncomeExpensePoint> data;
  final Color incomeColor;
  final Color expenseColor;
  final double height;
  final Color labelColor;

  const IncomeExpenseBarChart({
    super.key,
    required this.data,
    this.incomeColor = const Color(0xFF34C759),
    this.expenseColor = const Color(0xFF2F6BFF),
    this.height = 160,
    this.labelColor = const Color(0xFF8C8FA3),
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'Sin datos para este periodo',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BarChartPainter(
          data: data,
          incomeColor: incomeColor,
          expenseColor: expenseColor,
          labelColor: labelColor,
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<IncomeExpensePoint> data;
  final Color incomeColor;
  final Color expenseColor;
  final Color labelColor;

  _BarChartPainter({
    required this.data,
    required this.incomeColor,
    required this.expenseColor,
    this.labelColor = const Color(0xFF8C8FA3),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double maxValue = data
        .map((d) => d.income > d.expense ? d.income : d.expense)
        .fold<double>(0, (prev, el) => el > prev ? el : prev);

    final double safeMax = maxValue == 0 ? 1 : maxValue;

    const double labelHeight = 20;
    final double chartHeight = size.height - labelHeight;

    final double groupWidth = size.width / data.length;
    final double barWidth = (groupWidth * 0.28).clamp(6.0, 28.0);
    final double gap = barWidth * 0.35;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (int i = 0; i < data.length; i++) {
      final point = data[i];
      final double groupCenter = groupWidth * i + groupWidth / 2;

      final double incomeBarHeight =
          (point.income / safeMax) * (chartHeight - 8);
      final double expenseBarHeight =
          (point.expense / safeMax) * (chartHeight - 8);

      final double incomeX = groupCenter - gap / 2 - barWidth;
      final double expenseX = groupCenter + gap / 2;

      final incomeRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          incomeX,
          chartHeight - incomeBarHeight,
          barWidth,
          incomeBarHeight,
        ),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );
      final expenseRect = RRect.fromRectAndCorners(
        Rect.fromLTWH(
          expenseX,
          chartHeight - expenseBarHeight,
          barWidth,
          expenseBarHeight,
        ),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      canvas.drawRRect(incomeRect, Paint()..color = incomeColor);
      canvas.drawRRect(expenseRect, Paint()..color = expenseColor);

      textPainter.text = TextSpan(
        text: point.label,
        style: TextStyle(color: labelColor, fontSize: 11),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          groupCenter - textPainter.width / 2,
          chartHeight + 4,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.incomeColor != incomeColor ||
        oldDelegate.expenseColor != expenseColor;
  }
}
