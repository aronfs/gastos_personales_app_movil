import 'package:gastos_personales/layers/login/data/source/network/api.dart';
import 'package:gastos_personales/layers/login/domain/repository/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final Api _api;

  LoginRepositoryImpl({required Api api}) : _api = api;

  @override
  Future<String> login(String username, String password) =>
      _api.login(username, password);
}
