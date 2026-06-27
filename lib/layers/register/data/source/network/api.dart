import 'package:dio/dio.dart';
import 'package:gastos_personales/layers/register/data/dto/register_response.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class RegisterApi {
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
}

class RegisterApiImpl implements RegisterApi {
  final dio = Dio();

  @override
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );
      return RegisterResponse.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Failed to register: ${e.response?.statusCode} ${e.message}',
      );
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }
}
