import 'package:dio/dio.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

abstract class MovementsApi {
  Future<List<Movement>> getMovements();
}

class MovementsApiImpl implements MovementsApi {
  final Dio _dio = Dio();

  @override
  Future<List<Movement>> getMovements() async {
    final token = await TokenStorage.getToken();

    try {
      final response = await _dio.get(
        ApiEndpoints.movements,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
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
