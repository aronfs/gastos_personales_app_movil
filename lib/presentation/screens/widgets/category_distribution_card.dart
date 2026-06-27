import 'package:flutter/material.dart';
import 'category_donut_chart.dart';
import 'category_legend_row.dart';
import 'category_share.dart';
import 'report_card.dart';

/// Card completa de "Distribución por categoría": título, gráfico de dona
/// con el total al centro, y lista de categorías con su porcentaje.
class CategoryDistributionCard extends StatelessWidget {
  final String totalLabel;
  final List<CategoryShare> categories;

  const CategoryDistributionCard({
    super.key,
    required this.totalLabel,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por categoría',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategoryDonutChart(
                categories: categories,
                centerLabel: totalLabel,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories
                      .map((c) => CategoryLegendRow(category: c))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
