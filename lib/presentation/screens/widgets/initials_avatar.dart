import 'package:flutter/material.dart';

/// Avatar circular translúcido que muestra las iniciales del usuario,
/// pensado para usarse sobre fondos con gradiente.
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;

  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 84,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.33,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
