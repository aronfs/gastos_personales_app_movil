import 'package:flutter/material.dart';
import 'package:gastos_personales/navigation/route.dart';

class BalanceCard extends StatelessWidget {
  final String head;
  final String title;
  final String subtitle;
  final double valueBalance;
  final double valueIn;
  final double valueEnough;

  const BalanceCard({
    super.key,
    required this.head,
    required this.title,
    required this.subtitle,
    required this.valueBalance,
    required this.valueIn,
    required this.valueEnough,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [cs.primaryFixedDim, cs.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            head,
            style: tt.labelSmall?.copyWith(
              color: cs.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$ $valueBalance',
            style: tt.displayMedium?.copyWith(
              color: cs.onPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, income),
                 
                    child: _SubCard(
                      icon: Icons.arrow_downward_rounded,
                      label: title,
                      amount: '\$ $valueIn',
                      iconColor: cs.tertiaryFixedDim,
                      onPrimary: cs.onPrimary,
                    ),
                  ),
                
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, expenses),
                
                    child: _SubCard(
                      icon: Icons.arrow_upward_rounded,
                      label: subtitle,
                      amount: '\$ $valueEnough',
                      iconColor: cs.errorContainer,
                      onPrimary: cs.onPrimary,
                    ),
                  
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color iconColor;
  final Color onPrimary;

  const _SubCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.iconColor,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: tt.labelSmall?.copyWith(
                  color: onPrimary.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: tt.headlineMedium?.copyWith(color: onPrimary, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
