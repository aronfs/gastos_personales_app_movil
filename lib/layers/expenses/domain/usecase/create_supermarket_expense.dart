import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class CreateSupermarketExpense {
  final ExpensesRepository _repository;

  CreateSupermarketExpense(this._repository);

  Future<Movement> call({
    required String categoryId,
    required String description,
    required String transactionDate,
    required List<Map<String, dynamic>> products,
  }) =>
      _repository.createSupermarketExpense(
        categoryId: categoryId,
        description: description,
        transactionDate: transactionDate,
        products: products,
      );
}
