import 'package:flutter/material.dart';

class SettingsRowDivider extends StatelessWidget {
  const SettingsRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: cs.outlineVariant,
      ),
    );
  }
}
