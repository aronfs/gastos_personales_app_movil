import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class MovementsApi {
  Future<List<Movement>> getMovements();
}

class MovementsApiImpl implements MovementsApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Movement>> getMovements() async {
    try {
      final response = await _dio.get(ApiEndpoints.movements);
      return MovementDto.listFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Movements error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
