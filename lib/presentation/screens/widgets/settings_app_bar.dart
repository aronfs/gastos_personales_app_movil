import 'package:flutter/material.dart';

/// App bar personalizado: botón circular de retroceso a la izquierda,
/// título centrado-izquierda, y botón circular de notificaciones a la
/// derecha.
class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;

  const SettingsAppBar({
    super.key,
    required this.title,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new,
            iconSize: 16,
            color: cs.onSurface,
            bgColor: cs.surfaceContainerLow,
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: tt.headlineMedium?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const _CircleIconButton({
    required this.icon,
    required this.iconSize,
    required this.color,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }
}
