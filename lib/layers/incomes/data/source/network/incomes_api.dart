import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class IncomesApi {
  Future<List<Movement>> getIncomes();
  Future<Movement> createIncome(Map<String, dynamic> body);
  Future<Movement> updateIncome(String id, Map<String, dynamic> body);
  Future<void> deleteIncome(String id);
}

class IncomesApiImpl implements IncomesApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Movement>> getIncomes() async {
    try {
      final response = await _dio.get(ApiEndpoints.incomes);
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
      await _dio.delete('${ApiEndpoints.incomes}/$id');
    } on DioException catch (e) {
      throw Exception(
        'Delete income error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
