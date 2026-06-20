import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class CreateExpense {
  final ExpensesRepository _repository;

  CreateExpense(this._repository);

  Future<Movement> call({
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _repository.createExpense(
    amount: amount,
    description: description,
    categoryId: categoryId,
    transactionDate: transactionDate,
  );
}
