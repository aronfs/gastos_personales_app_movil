import 'package:gastos_personales/layers/login/domain/repository/login_repository.dart';

class SignIn {
  SignIn({required this._repository});

  final LoginRepository _repository;

  Future<String> call(String email, String password) async {
    return await _repository.login(email, password);
  }
}
