import 'package:flutter/material.dart';

/// App bar de tema oscuro: botón circular de retroceso, subtítulo pequeño
/// encima del título centrado, y botón de notificaciones.
class DarkPageAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final VoidCallback? onNotificationsTap;

  const DarkPageAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Botón back
        Material(
          color: const Color(0xFF1E2235),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Título central
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7090),
                    letterSpacing: 0.8,
                  ),
                ),
              if (subtitle != null) const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // Botón campana
        Material(
          color: const Color(0xFF1E2235),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onNotificationsTap,
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.notifications_none,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
