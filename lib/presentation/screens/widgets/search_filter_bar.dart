import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const SearchFilterBar({
    super.key,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 15,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
