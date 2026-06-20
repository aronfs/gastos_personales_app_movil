import 'package:gastos_personales/layers/incomes/domain/repository/incomes_repository.dart';

class DeleteIncome {
  final IncomesRepository _repository;

  DeleteIncome(this._repository);

  Future<void> call(String id) => _repository.deleteIncome(id);
}
