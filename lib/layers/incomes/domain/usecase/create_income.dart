import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/incomes/domain/repository/incomes_repository.dart';

class CreateIncome {
  final IncomesRepository _repository;

  CreateIncome(this._repository);

  Future<Movement> call({
    required String categoryId,
    required double amount,
    required String description,
    required String transactionDate,
  }) => _repository.createIncome(
    categoryId: categoryId,
    amount: amount,
    description: description,
    transactionDate: transactionDate,
  );
}
