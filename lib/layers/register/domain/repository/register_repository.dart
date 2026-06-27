import 'package:gastos_personales/layers/register/data/dto/register_response.dart';

abstract class RegisterRepository {
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
}
