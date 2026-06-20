import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

abstract class IncomesRepository {
  Future<List<Movement>> getIncomes();
  Future<Movement> createIncome({
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  });
  Future<Movement> updateIncome({
    required String id,
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  });
  Future<void> deleteIncome(String id);
}
