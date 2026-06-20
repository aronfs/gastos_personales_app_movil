/// Representa el ingreso y gasto de un punto en el tiempo (ej. una semana del mes).
class IncomeExpensePoint {
  final String label;
  final double income;
  final double expense;

  const IncomeExpensePoint({
    required this.label,
    required this.income,
    required this.expense,
  });
}
