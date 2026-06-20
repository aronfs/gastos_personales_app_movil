import 'package:flutter/material.dart';
import 'settings_row_divider.dart';

/// Card blanca redondeada que agrupa varias filas de configuración,
/// insertando un divisor automáticamente entre cada una.
class SettingsGroupCard extends StatelessWidget {
  final List<Widget> rows;

  const SettingsGroupCard({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
