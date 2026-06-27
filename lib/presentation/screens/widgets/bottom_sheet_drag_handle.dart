import 'package:flutter/material.dart';

/// Indicador de arrastre (drag handle) para bottom sheets:
/// pastilla gris centrada en la parte inferior del sheet.
class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 48,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFFDCDEE6),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
