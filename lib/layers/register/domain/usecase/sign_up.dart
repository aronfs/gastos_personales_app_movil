import 'package:gastos_personales/layers/register/data/dto/register_response.dart';
import 'package:gastos_personales/layers/register/domain/repository/register_repository.dart';

class SignUp {
  final RegisterRepository _repository;

  SignUp({required this._repository});

  Future<RegisterResponse> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return _repository.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
