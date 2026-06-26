import 'package:flutter/material.dart';

class PrimaryActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.color = const Color(0xFF2563EB),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bgColor = color == const Color(0xFF2563EB) ? cs.primary : color;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            style: tt.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
