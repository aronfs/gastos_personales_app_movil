import 'package:gastos_personales/layers/expenses/data/source/network/expenses_api.dart';
import 'package:gastos_personales/layers/expenses/domain/repository/expenses_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesApi _api;

  ExpensesRepositoryImpl(this._api);

  Map<String, dynamic> _body({
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => {
    'amount': amount,
    'description': description,
    'categoryId': categoryId,
    'transactionDate': transactionDate,
  };

  @override
  Future<List<Movement>> getExpenses() => _api.getExpenses();

  @override
  Future<Movement> createExpense({
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _api.createExpense(
    _body(
      amount: amount,
      description: description,
      categoryId: categoryId,
      transactionDate: transactionDate,
    ),
  );

  @override
  Future<Movement> createSupermarketExpense({
    required String categoryId,
    required String description,
    required String transactionDate,
    required List<Map<String, dynamic>> products,
  }) => _api.createSupermarketExpense({
    'categoryId': categoryId,
    'description': description,
    'transactionDate': transactionDate,
    'products': products,
  });

  @override
  Future<Movement> updateExpense({
    required String id,
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _api.updateExpense(
    id,
    _body(
      amount: amount,
      description: description,
      categoryId: categoryId,
      transactionDate: transactionDate,
    ),
  );

  @override
  Future<void> deleteExpense(String id) => _api.deleteExpense(id);
}
