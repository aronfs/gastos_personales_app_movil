import 'package:gastos_personales/layers/register/data/dto/register_response.dart';
import 'package:gastos_personales/layers/register/data/source/network/api.dart';
import 'package:gastos_personales/layers/register/domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterApi _api;

  RegisterRepositoryImpl({required this._api});

  @override
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) =>
      _api.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
}
