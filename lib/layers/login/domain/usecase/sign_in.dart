import 'package:gastos_personales/layers/login/data/dto/login_response.dart';
import 'package:gastos_personales/layers/login/domain/repository/login_repository.dart';

class SignIn {
  SignIn({required this._repository});

  final LoginRepository _repository;

  Future<LoginResponse> call(String email, String password) async {
    return _repository.login(email, password);
  }
}
