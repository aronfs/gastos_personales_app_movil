import 'package:dio/dio.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class Api {
  Future<String> login(String username, String password);
}

class ApiImpl implements Api {
  final dio = Dio();

  @override
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      
     final accessToken = response.data['data']['accessToken'] as String;
     return accessToken;
    } on DioException catch (e) {
      throw Exception(
        'Failed to login: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
