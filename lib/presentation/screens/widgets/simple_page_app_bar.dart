import 'package:flutter/material.dart';

/// App bar simple: título a la izquierda y botón circular de
/// notificaciones a la derecha. Usado en pantallas raíz como
/// "Gastos", "Ingresos" o "Categorías".
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        Material(
          color: const Color(0xFFF2F3F7),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onNotificationsTap,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(
                Icons.notifications_none,
                size: 22,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
