import 'package:flutter/material.dart';
import 'quick_action.dart';

/// Tarjeta individual de acción rápida: icono en círculo pastel,
/// título en negrita y subtítulo descriptivo. Esquinas redondeadas
/// con sombra sutil.
class QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const QuickActionCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono en círculo de color pastel
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: action.iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  action.icon,
                  size: 22,
                  color: action.iconColor,
                ),
              ),
              const SizedBox(height: 14),
              // Título
              Text(
                action.title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              // Subtítulo
              Text(
                action.subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  color: cs.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
