import 'package:gastos_personales/layers/login/data/dto/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponse> login(String email, String password);
}
