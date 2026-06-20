import 'package:flutter/material.dart';
import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';

/// Muestra una fila de chips con el resumen por categoría (ingresos o gastos).
class CategorySummaryCard extends StatelessWidget {
  final String title;
  final List<CategoryItem> items;
  final bool isExpense;

  const CategorySummaryCard({
    super.key,
    required this.title,
    required this.items,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isExpense
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 16,
                color: isExpense ? cs.error : cs.tertiary,
              ),
              const SizedBox(width: 6),
              Text(title, style: tt.titleMedium),
            ],
          ),
          const SizedBox(height: 12),
          if (items.isEmpty)
            Text(
              'Sin movimientos',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            )
          else
            ...items.map(
              (item) => _CategoryRow(item: item, isExpense: isExpense),
            ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryItem item;
  final bool isExpense;

  const _CategoryRow({required this.item, required this.isExpense});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final amountColor = isExpense ? cs.error : cs.tertiary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isExpense ? cs.errorContainer : cs.tertiaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.category_outlined,
              size: 18,
              color: isExpense ? cs.error : cs.tertiary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.categoryName, style: tt.bodyMedium),
                Text(
                  '${item.count} movimiento${item.count != 1 ? 's' : ''}',
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            '\$ ${item.total.toStringAsFixed(2)}',
            style: tt.titleMedium?.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
