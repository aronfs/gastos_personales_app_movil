import 'package:flutter/material.dart';

/// Muestra el cupo/presupuesto disponible con una barra de progreso.
/// El cupo disminuye a medida que se agregan artículos.
class BudgetCard extends StatelessWidget {
  /// Cupo inicial (presupuesto total)
  final double budget;

  /// Total gastado hasta ahora
  final double spent;

  /// Callback para editar el cupo
  final VoidCallback? onEditBudget;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.spent,
    this.onEditBudget,
  });

  double get remaining => budget - spent;
  double get progress => budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => spent > budget;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Colores según estado
    final progressColor = isOverBudget
        ? cs.error
        : progress > 0.8
        ? const Color(0xFFF59E0B) // Advertencia si pasa el 80%
        : cs.tertiary;

    final remainingColor = isOverBudget ? cs.error : cs.onSurface;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
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
          // ── Header: Cupo + botón editar ─────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 18,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cupo',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (onEditBudget != null)
                GestureDetector(
                  onTap: onEditBudget,
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined, size: 16, color: cs.primary),
                      const SizedBox(width: 4),
                      Text(
                        '\$ ${budget.toStringAsFixed(2)}',
                        style: tt.bodyMedium?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  '\$ ${budget.toStringAsFixed(2)}',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Barra de progreso ────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: cs.surfaceContainerHigh,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
          const SizedBox(height: 12),

          // ── Labels: Gastado / Disponible ──────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusLabel(
                label: 'Gastado',
                value: '\$ ${spent.toStringAsFixed(2)}',
                color: cs.onSurfaceVariant,
              ),
              _StatusLabel(
                label: 'Disponible',
                value: '\$ ${remaining.toStringAsFixed(2)}',
                color: remainingColor,
                isBold: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isBold;

  const _StatusLabel({
    required this.label,
    required this.value,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: tt.labelSmall?.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
