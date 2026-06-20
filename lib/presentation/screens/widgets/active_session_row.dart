import 'package:flutter/material.dart';
import 'settings_leading_icon.dart';
import 'status_badge.dart';

/// Fila que representa una sesión activa: icono de dispositivo, nombre,
/// ubicación/estado, y un badge opcional (ej. "Actual").
class ActiveSessionRow extends StatelessWidget {
  final IconData icon;
  final String deviceName;
  final String locationInfo;
  final String? badgeLabel;

  const ActiveSessionRow({
    super.key,
    required this.icon,
    required this.deviceName,
    required this.locationInfo,
    this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SettingsLeadingIcon(icon: icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  locationInfo,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF9A9DB0),
                  ),
                ),
              ],
            ),
          ),
          if (badgeLabel != null) StatusBadge(label: badgeLabel!),
        ],
      ),
    );
  }
}
