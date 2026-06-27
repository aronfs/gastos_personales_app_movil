import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/login/data/dto/login_response.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/biometric_service.dart';
import 'package:gastos_personales/util/session_manager.dart';
import 'package:gastos_personales/util/token_storage.dart';

class AuthRepository {
  final BiometricService _biometricService;

  AuthRepository({BiometricService? biometricService})
    : _biometricService = biometricService ?? BiometricService();

  Future<LoginResponse> loginWithBiometric() async {
    final enabled = await TokenStorage.isBiometricEnabled();
    final hasRefreshToken = await TokenStorage.hasRefreshToken();
    if (!enabled || !hasRefreshToken) {
      await TokenStorage.setBiometricEnabled(false);
      throw Exception('Sesión expirada. Inicia sesión nuevamente.');
    }

    final authenticated = await _biometricService.authenticate();
    if (!authenticated) {
      throw Exception('Autenticación cancelada');
    }
    return refreshSession();
  }

  Future<LoginResponse> refreshSession() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await SessionManager().forceLogout();
      throw Exception('Sesión expirada. Inicia sesión nuevamente.');
    }

    try {
      final dio = DioClient().dio;
      final response = await dio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await TokenStorage.saveToken(newAccessToken);
      await TokenStorage.saveRefreshToken(newRefreshToken);

      return LoginResponse(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        userId: '',
        sessionId: '',
      );
    } on DioException {
      await SessionManager().forceLogout();
      throw Exception('Sesión expirada. Inicia sesión nuevamente.');
    }
  }

  Future<void> enableBiometric() async {
    final hasRefreshToken = await TokenStorage.hasRefreshToken();
    if (!hasRefreshToken) {
      throw Exception(
        'Inicia sesión con contraseña antes de activar la huella.',
      );
    }

    final authenticated = await _biometricService.authenticateForEnable();
    if (!authenticated) {
      throw Exception('Autenticación cancelada');
    }
    await TokenStorage.setBiometricEnabled(true);
  }

  Future<void> disableBiometric() async {
    await TokenStorage.setBiometricEnabled(false);
  }
}
