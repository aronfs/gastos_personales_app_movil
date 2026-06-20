import 'package:dio/dio.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

abstract class IncomesApi {
  Future<List<Movement>> getIncomes();
  Future<Movement> createIncome(Map<String, dynamic> body);
  Future<Movement> updateIncome(String id, Map<String, dynamic> body);
  Future<void> deleteIncome(String id);
}

class IncomesApiImpl implements IncomesApi {
  final Dio _dio = Dio();

  Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();
    return {'Authorization': 'Bearer $token'};
  }

  @override
  Future<List<Movement>> getIncomes() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.incomes,
        options: Options(headers: await _headers()),
      );
      return MovementDto.listFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Incomes error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Movement> createIncome(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.incomes,
        data: body,
        options: Options(headers: await _headers()),
      );
      return MovementDto.fromMap(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Create income error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Movement> updateIncome(String id, Map<String, dynamic> body) async {
    try {
      final response = await _dio.put(
        '${ApiEndpoints.incomes}/$id',
        data: body,
        options: Options(headers: await _headers()),
      );
      return MovementDto.fromMap(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Update income error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<void> deleteIncome(String id) async {
    try {
      await _dio.delete(
        '${ApiEndpoints.incomes}/$id',
        options: Options(headers: await _headers()),
      );
    } on DioException catch (e) {
      throw Exception(
        'Delete income error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
