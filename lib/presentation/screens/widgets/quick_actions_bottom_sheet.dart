import 'package:flutter/material.dart';
import 'bottom_sheet_drag_handle.dart';
import 'quick_action.dart';
import 'quick_actions_grid.dart';
import 'shortcuts_tab_bar.dart';

/// Bottom sheet de "Acciones rápidas (+)": grid de acciones en 2
/// columnas, barra de tabs de atajos, botón Cancelar y drag handle.
///
/// Uso:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   isScrollControlled: true,
///   builder: (_) => const QuickActionsBottomSheet(),
/// );
/// ```
class QuickActionsBottomSheet extends StatefulWidget {
  final List<QuickAction> actions;
  final VoidCallback? onCancel;

  const QuickActionsBottomSheet({
    super.key,
    required this.actions,
    this.onCancel,
  });

  @override
  State<QuickActionsBottomSheet> createState() =>
      _QuickActionsBottomSheetState();
}

class _QuickActionsBottomSheetState extends State<QuickActionsBottomSheet> {
  int _selectedTab = 0;

  static const List<ShortcutTab> _tabs = [
    ShortcutTab(icon: Icons.sell_outlined, label: 'Atajos'),
    ShortcutTab(icon: Icons.sell_outlined),
    ShortcutTab(icon: Icons.calendar_today_outlined),
    ShortcutTab(icon: Icons.grid_view_outlined),
    ShortcutTab(icon: Icons.favorite_border),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid de acciones rápidas
          QuickActionsGrid(actions: widget.actions),
          const SizedBox(height: 20),

          // Divider + Barra de Atajos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cs.outlineVariant, width: 1),
            ),
            child: ShortcutsTabBar(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onSelected: (i) => setState(() => _selectedTab = i),
            ),
          ),
          const SizedBox(height: 12),

          // Botón Cancelar
          Material(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: widget.onCancel ?? () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: cs.outlineVariant, width: 1),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Drag handle
          const BottomSheetDragHandle(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
