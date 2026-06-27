import 'package:flutter/material.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';

class ProfileStatusBadge extends StatelessWidget {
  final bool active;
  final bool isLight;

  const ProfileStatusBadge({
    super.key,
    required this.active,
    required this.isLight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final loc = AppLocalizations.of(context)!;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? cs.tertiary.withValues(alpha: 0.12)
            : cs.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: active
              ? cs.tertiary.withValues(alpha: 0.3)
              : cs.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? cs.tertiary : cs.error,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            active ? loc.active : loc.inactive,
            style: tt.labelSmall?.copyWith(
              color: active ? cs.tertiary : cs.error,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
