import 'package:flutter/material.dart';

/// App bar simple: título a la izquierda y botón circular de
/// notificaciones a la derecha.
class SimplePageAppBar extends StatelessWidget {
  final String title;

  const SimplePageAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Text(
      title,
      style: tt.headlineLarge?.copyWith(
        color: cs.onSurface,
      ),
    );
  }
}
