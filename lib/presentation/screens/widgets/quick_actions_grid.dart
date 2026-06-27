import 'package:flutter/material.dart';
import 'quick_action.dart';
import 'quick_action_card.dart';

/// Grid de acciones rápidas en 2 columnas. Si el número de ítems
/// es impar, el último ocupa solo la columna izquierda para respetar
/// el diseño (no estira la tarjeta al ancho completo).
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final double spacing;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    int i = 0;

    while (i < actions.length) {
      final bool hasRight = i + 1 < actions.length;

      rows.add(
        Row(
          children: [
            Expanded(
              child: QuickActionCard(action: actions[i]),
            ),
            SizedBox(width: spacing),
            Expanded(
              child: hasRight
                  ? QuickActionCard(action: actions[i + 1])
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < actions.length) {
        rows.add(SizedBox(height: spacing));
      }
      i += 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}
