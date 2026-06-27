import 'package:flutter/material.dart';
import 'category_item.dart';
import 'most_used_category_row.dart';
import 'report_card.dart';

/// Card que agrupa las categorías más usadas, cada una con su monto
/// total acumulado.
class MostUsedCategoriesCard extends StatelessWidget {
  final List<CategoryItem> categories;
  final List<String> amountLabels;

  const MostUsedCategoriesCard({
    super.key,
    required this.categories,
    required this.amountLabels,
  }) : assert(categories.length == amountLabels.length);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ReportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Más usadas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < categories.length; i++)
            MostUsedCategoryRow(
              category: categories[i],
              amountLabel: amountLabels[i],
            ),
        ],
      ),
    );
  }
}
