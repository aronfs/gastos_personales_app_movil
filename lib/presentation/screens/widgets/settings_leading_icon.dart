import 'package:flutter/material.dart';

class SettingsLeadingIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const SettingsLeadingIcon({
    super.key,
    required this.icon,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: size * 0.5, color: cs.onSurfaceVariant),
    );
  }
}
