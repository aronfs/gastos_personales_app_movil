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
    final cs = Theme.of(context).colorScheme;
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
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  locationInfo,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: cs.onSurfaceVariant,
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
