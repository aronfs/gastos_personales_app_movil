import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class UpdateExpense {
  final ExpensesRepository _repository;

  UpdateExpense(this._repository);

  Future<Movement> call({
    required String id,
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _repository.updateExpense(
    id: id,
    amount: amount,
    description: description,
    categoryId: categoryId,
    transactionDate: transactionDate,
  );
}
