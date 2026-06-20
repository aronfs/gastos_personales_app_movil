import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/incomes/domain/repository/incomes_repository.dart';

class GetIncomes {
  final IncomesRepository _repository;

  GetIncomes(this._repository);

  Future<List<Movement>> call() => _repository.getIncomes();
}
