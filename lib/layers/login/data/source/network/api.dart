import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/login/data/dto/login_response.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class Api {
  Future<LoginResponse> login(String username, String password);
}

class ApiImpl implements Api {
  final Dio _dio = DioClient().dio;

  @override
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      return LoginResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to login: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
