import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/incomes/domain/repository/incomes_repository.dart';

class UpdateIncome {
  final IncomesRepository _repository;

  UpdateIncome(this._repository);

  Future<Movement> call({
    required String id,
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  }) =>
      _repository.updateIncome(
        id: id,
        categoryId: categoryId,
        amount: amount,
        description: description,
        transactionDate: transactionDate,
      );
}
