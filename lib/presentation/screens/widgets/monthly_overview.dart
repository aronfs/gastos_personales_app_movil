import 'package:flutter/material.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';

class MonthlyOverview extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const MonthlyOverview({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.date_range_rounded, color: cs.tertiary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                loc.monthlySummary,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.savings_rounded, color: cs.secondary, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    loc.balanceLabel,
                    style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: balance >= 0 ? cs.primary : cs.error,
                  ),
                ),
              ],
            ),
          ),
          if (income > 0) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: (expense / income).clamp(0.0, 1.0),
                backgroundColor: cs.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(
                  expense > income ? cs.error : cs.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              loc.incomePercentage(((expense / income) * 100).toStringAsFixed(0)),
              style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
