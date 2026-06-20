import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

abstract class ExpensesRepository {
  Future<List<Movement>> getExpenses();
  Future<Movement> createExpense({
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  });
  Future<Movement> createSupermarketExpense({
    required String categoryId,
    required String description,
    required String transactionDate,
    required List<Map<String, dynamic>> products,
  });
  Future<Movement> updateExpense({
    required String id,
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  });
  Future<void> deleteExpense(String id);
}
