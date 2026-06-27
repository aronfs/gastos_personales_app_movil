import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class ExpensesApi {
  Future<List<Movement>> getExpenses();
  Future<Movement> createExpense(Map<String, dynamic> body);
  Future<Movement> createSupermarketExpense(Map<String, dynamic> body);
  Future<Movement> updateExpense(String id, Map<String, dynamic> body);
  Future<void> deleteExpense(String id);
}

class ExpensesApiImpl implements ExpensesApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Movement>> getExpenses() async {
    try {
      final response = await _dio.get(ApiEndpoints.expenses);
      return MovementDto.listFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Expenses error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Movement> createExpense(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.expenses,
        data: body,
      );
      return MovementDto.fromMap(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Create expense error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Movement> createSupermarketExpense(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.expensesSupermarket,
        data: body,
      );
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      
      // El backend retorna solo expense_id, total y un array de products
      // Retornamos un Movement básico ya que el bloc no utiliza todos los campos
      return Movement(
        id: data['expense_id']?.toString() ?? '',
        type: MovementType.expense,
        amount: double.tryParse(data['total']?.toString() ?? '0') ?? 0.0,
        description: body['description'] as String? ?? 'Supermercado',
        category: MovementCategory(
          id: body['categoryId'] as String? ?? '',
          name: 'Supermercado',
          icon: 'shopping_cart',
          color: '#000000',
        ),
        transactionDate: body['transactionDate'] as String? ?? '',
        createdAt: DateTime.now().toIso8601String(),
        expenseProducts: const [],
      );
    } on DioException catch (e) {
      throw Exception(
        'Create supermarket expense error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Movement> updateExpense(String id, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.expenses}/$id',
        data: body,
      );
      return MovementDto.fromMap(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Update expense error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _dio.delete('${ApiEndpoints.expenses}/$id');
    } on DioException catch (e) {
      throw Exception(
        'Delete expense error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
