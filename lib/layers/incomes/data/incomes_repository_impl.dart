import 'package:gastos_personales/layers/incomes/data/source/network/incomes_api.dart';
import 'package:gastos_personales/layers/incomes/domain/repository/incomes_repository.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class IncomesRepositoryImpl implements IncomesRepository {
  final IncomesApi _api;

  IncomesRepositoryImpl(this._api);

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
  Future<List<Movement>> getIncomes() => _api.getIncomes();

  @override
  Future<Movement> createIncome({
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _api.createIncome(
    _body(
      amount: amount,
      description: description,
      categoryId: categoryId,
      transactionDate: transactionDate,
    ),
  );

  @override
  Future<Movement> updateIncome({
    required String id,
    required double amount,
    required String description,
    required String categoryId,
    required String transactionDate,
  }) => _api.updateIncome(
    id,
    _body(
      amount: amount,
      description: description,
      categoryId: categoryId,
      transactionDate: transactionDate,
    ),
  );

  @override
  Future<void> deleteIncome(String id) => _api.deleteIncome(id);
}
