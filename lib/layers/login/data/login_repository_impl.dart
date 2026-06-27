import 'package:gastos_personales/layers/login/data/dto/login_response.dart';
import 'package:gastos_personales/layers/login/data/source/network/api.dart';
import 'package:gastos_personales/layers/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final Api _api;

  LoginRepositoryImpl({required this._api});

  @override
  Future<LoginResponse> login(String username, String password) =>
      _api.login(username, password);
}
