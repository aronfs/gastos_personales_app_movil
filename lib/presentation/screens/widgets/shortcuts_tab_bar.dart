import 'package:flutter/material.dart';

/// Modelo de un tab en la barra de atajos.
class ShortcutTab {
  final IconData icon;
  final String? label; // Solo el tab activo muestra label
  const ShortcutTab({required this.icon, this.label});
}

/// Barra horizontal de tabs para la sección "Atajos":
/// el tab activo muestra icono + texto, los inactivos solo icono.
class ShortcutsTabBar extends StatelessWidget {
  final List<ShortcutTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ShortcutsTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: tabs.asMap().entries.map((entry) {
        final int idx = entry.key;
        final ShortcutTab tab = entry.value;
        final bool isActive = idx == selectedIndex;

        return Padding(
          padding: EdgeInsets.only(right: idx < tabs.length - 1 ? 8 : 0),
          child: GestureDetector(
            onTap: () => onSelected(idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: isActive ? 14 : 10,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? cs.surfaceContainerHigh
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    size: 18,
                    color: isActive
                        ? cs.onSurface
                        : cs.onSurfaceVariant,
                  ),
                  if (isActive && tab.label != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      tab.label!,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
