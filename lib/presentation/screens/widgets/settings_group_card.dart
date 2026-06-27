import 'package:flutter/material.dart';
import 'settings_row_divider.dart';

/// Card blanca redondeada que agrupa varias filas de configuración,
/// insertando un divisor automáticamente entre cada una.
class SettingsGroupCard extends StatelessWidget {
  final List<Widget> rows;

  const SettingsGroupCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: cs.surfaceContainerHigh,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1) const SettingsRowDivider(),
          ],
        ],
      ),
    );
  }
}
