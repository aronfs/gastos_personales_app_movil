import 'package:flutter/material.dart';
import 'camera_action_button.dart';

/// Barra de acciones de cámara: contenedor oscuro redondeado con
/// Linterna, Galería, Cámara (activo), Manual y Reintentar.
class CameraActionsBar extends StatelessWidget {
  final int activeIndex;
  final List<VoidCallback?> onTaps;

  const CameraActionsBar({
    super.key,
    this.activeIndex = 2,
    this.onTaps = const [null, null, null, null, null],
  });

  static const List<_ActionDef> _actions = [
    _ActionDef(icon: Icons.flashlight_on_outlined, label: 'Linterna'),
    _ActionDef(icon: Icons.photo_library_outlined, label: 'Galería'),
    _ActionDef(icon: Icons.camera_alt_outlined, label: ''),
    _ActionDef(icon: Icons.tune, label: 'Manual'),
    _ActionDef(icon: Icons.refresh, label: 'Reintentar'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151829),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_actions.length, (index) {
          final def = _actions[index];
          return CameraActionButton(
            icon: def.icon,
            label: def.label,
            isActive: index == activeIndex,
            onTap: index < onTaps.length ? onTaps[index] : null,
          );
        }),
      ),
    );
  }
}

class _ActionDef {
  final IconData icon;
  final String label;
  const _ActionDef({required this.icon, required this.label});
}
