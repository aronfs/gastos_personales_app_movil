import 'package:flutter/material.dart';

class SavingsRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final double valueSaving;
  final double valueGoal;

  const SavingsRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.valueGoal,
    required this.valueSaving,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.trending_up_rounded,
            iconBgColor: cs.tertiaryContainer,
            iconColor: cs.tertiary,
            label: title,
            value: '\$ $valueSaving',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.label_outline_rounded,
            iconBgColor: cs.secondaryContainer,
            iconColor: cs.secondary,
            label: subtitle,
            value: '%$valueGoal',
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.value,
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
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.headlineMedium?.copyWith(
              color: cs.onSurface,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
