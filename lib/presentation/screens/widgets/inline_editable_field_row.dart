import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto inline que reemplaza a FormFieldRow para datos editables.
/// Mantiene el mismo diseño visual pero con un TextField real en lugar de un dialog.
class InlineEditableFieldRow extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const InlineEditableFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.iconBackgroundColor = const Color(0xFFF2F3F7),
    this.iconColor = const Color(0xFF2A2D3A),
    this.hintText = '',
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cs.outlineVariant, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: tt.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    readOnly: readOnly,
                    enabled: enabled,
                    maxLines: maxLines,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    style: tt.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                      prefixText: prefixText,
                      prefixStyle: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
