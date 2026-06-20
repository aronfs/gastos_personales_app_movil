import 'package:flutter/material.dart';
import 'income_expense_bar_chart.dart';
import 'income_expense_point.dart';
import 'legend_dot.dart';
import 'report_card.dart';

/// Card completa de "Ingresos vs Gastos": título, subtítulo de fecha,
/// gráfico de barras y leyenda inferior.
class IncomeExpenseCard extends StatelessWidget {
  final String periodLabel;
  final List<IncomeExpensePoint> data;
  final Color incomeColor;
  final Color expenseColor;

  const IncomeExpenseCard({
    super.key,
    required this.periodLabel,
    required this.data,
    this.incomeColor = const Color(0xFF34C759),
    this.expenseColor = const Color(0xFF2F6BFF),
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingresos vs Gastos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                periodLabel,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9A9DB0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IncomeExpenseBarChart(
            data: data,
            incomeColor: incomeColor,
            expenseColor: expenseColor,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendDot(color: incomeColor, label: 'Ingresos'),
              const SizedBox(width: 20),
              LegendDot(color: expenseColor, label: 'Gastos'),
            ],
          ),
        ],
      ),
    );
  }
}
