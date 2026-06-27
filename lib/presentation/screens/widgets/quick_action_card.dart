import 'package:flutter/material.dart';
import 'quick_action.dart';

/// Tarjeta individual de acción rápida: icono en círculo pastel,
/// título en negrita y subtítulo descriptivo. Esquinas redondeadas
/// con sombra sutil.
class QuickActionCard extends StatelessWidget {
  final QuickAction action;

  const QuickActionCard({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: action.onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEEF0F4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono en círculo de color pastel
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: action.iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  action.icon,
                  size: 22,
                  color: action.iconColor,
                ),
              ),
              const SizedBox(height: 14),
              // Título
              Text(
                action.title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              // Subtítulo
              Text(
                action.subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF9A9DB0),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
