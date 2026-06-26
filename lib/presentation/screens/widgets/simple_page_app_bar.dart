import 'package:flutter/material.dart';

/// App bar simple: título a la izquierda y botón circular de
/// notificaciones a la derecha.
class SimplePageAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onNotificationsTap;

  const SimplePageAppBar({
    super.key,
    required this.title,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: tt.headlineLarge?.copyWith(
            color: cs.onSurface,
          ),
        ),
        Material(
          color: cs.surfaceContainerLow,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onNotificationsTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.notifications_none,
                size: 22,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
