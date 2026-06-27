import 'package:flutter/material.dart';

/// Calendario inline que se expande hacia abajo en lugar de abrir un dialog.
/// Muestra el header colapsado y el CalendarDatePicker al expandir.
class InlineCalendarPicker extends StatefulWidget {
  final String label;
  final DateTime selectedDate;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final ValueChanged<DateTime> onDateChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;

  const InlineCalendarPicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateChanged,
    this.icon = Icons.calendar_today_outlined,
    this.iconBackgroundColor = const Color(0xFFF2F3F7),
    this.iconColor = const Color(0xFF2A2D3A),
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  @override
  State<InlineCalendarPicker> createState() => _InlineCalendarPickerState();
}

class _InlineCalendarPickerState extends State<InlineCalendarPicker> {
  bool _isExpanded = false;

  String _formatDate(DateTime date) {
    final months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return '${date.day} de ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header colapsado ──
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.enabled
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _isExpanded ? cs.primary : cs.outlineVariant,
                  width: _isExpanded ? 1.5 : 1,
                ),
                color: _isExpanded
                    ? cs.primary.withValues(alpha: 0.04)
                    : cs.surfaceContainerLowest,
              ),
              child: Row(
                children: [
                  Text(
                    widget.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          _isExpanded ? cs.primary : cs.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(widget.selectedDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Vista previa compacta ──
        if (!_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: widget.iconBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(widget.icon, size: 16, color: widget.iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  _formatDate(widget.selectedDate),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Calendario expandido ──
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: cs.outlineVariant.withValues(alpha: 0.5)),
                color: cs.surfaceContainerLowest,
              ),
              child: CalendarDatePicker(
                initialDate: widget.selectedDate,
                firstDate: widget.firstDate ?? DateTime(2020),
                lastDate:
                    widget.lastDate ?? DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  widget.onDateChanged(date);
                  setState(() => _isExpanded = false);
                },
              ),
            ),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}
