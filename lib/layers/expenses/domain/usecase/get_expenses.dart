import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class GetExpenses {
  final ExpensesRepository _repository;

  GetExpenses(this._repository);

  Future<List<Movement>> call() => _repository.getExpenses();
}
