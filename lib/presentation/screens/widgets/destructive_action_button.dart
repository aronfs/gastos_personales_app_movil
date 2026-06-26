import 'package:flutter/material.dart';

class DestructiveActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const DestructiveActionButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.errorContainer,
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
              color: cs.error,
            ),
          ),
        ),
      ),
    );
  }
}
