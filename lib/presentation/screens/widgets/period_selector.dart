import 'package:flutter/material.dart';

enum ReportPeriod { semana, mes, anio }

extension ReportPeriodLabel on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.semana:
        return 'Semana';
      case ReportPeriod.mes:
        return 'Mes';
      case ReportPeriod.anio:
        return 'Año';
    }
  }
}

/// Selector segmentado tipo "pill" para elegir el periodo del reporte.
class PeriodSelector extends StatelessWidget {
  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  const PeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEFF3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: ReportPeriod.values.map((period) {
          final bool isSelected = period == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  period.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF1A1A2E)
                        : const Color(0xFF8C8FA3),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
