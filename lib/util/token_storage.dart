import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyBiometricEnabled = 'biometric_enabled';
  static const _keyUserId = 'user_id';
  static const _keySessionId = 'session_id';

  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _keyAccessToken, value: token);
  }

  static Future<String?> getToken() async {
    return _secureStorage.read(key: _keyAccessToken);
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: _keyAccessToken);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _keyRefreshToken, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _keyRefreshToken);
  }

  static Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearRefreshToken() async {
    await _secureStorage.delete(key: _keyRefreshToken);
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _keyBiometricEnabled,
      value: enabled ? 'true' : 'false',
    );
  }

  static Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _keyBiometricEnabled);
    return value == 'true';
  }

  static Future<void> saveUserId(String id) async {
    await _secureStorage.write(key: _keyUserId, value: id);
  }

  static Future<String?> getUserId() async {
    return _secureStorage.read(key: _keyUserId);
  }

  static Future<void> saveSessionId(String id) async {
    await _secureStorage.write(key: _keySessionId, value: id);
  }

  static Future<String?> getSessionId() async {
    return _secureStorage.read(key: _keySessionId);
  }

  static Future<void> clearSession({
    bool preserveBiometricLogin = false,
  }) async {
    if (!preserveBiometricLogin) {
      await clearAll();
      return;
    }

    final biometricEnabled = await isBiometricEnabled();
    final refreshToken = await getRefreshToken();

    await clearToken();
    await _secureStorage.delete(key: _keyUserId);
    await _secureStorage.delete(key: _keySessionId);

    if (!biometricEnabled || refreshToken == null || refreshToken.isEmpty) {
      await clearRefreshToken();
      await setBiometricEnabled(false);
    }
  }

  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
