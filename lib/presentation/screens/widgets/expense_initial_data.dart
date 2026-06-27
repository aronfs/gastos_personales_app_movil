/// Datos iniciales para precargar en NewExpensePage desde el escáner de facturas.
class ExpenseInitialData {
  final double amount;
  final String? description;

  const ExpenseInitialData({
    required this.amount,
    this.description,
  });
}
