import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';

class DeleteExpense {
  final ExpensesRepository _repository;

  DeleteExpense(this._repository);

  Future<void> call(String id) => _repository.deleteExpense(id);
}
