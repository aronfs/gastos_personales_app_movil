import 'package:shared_preferences/shared_preferences.dart';

/// Gestiona la persistencia del access token en SharedPreferences.
class TokenStorage {
  TokenStorage._();

  static const _keyAccessToken = 'access_token';

  /// Guarda el [token] en SharedPreferences.
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, token);
  }

  /// Devuelve el token almacenado, o `null` si no existe.
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  /// Elimina el token (logout).
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
  }

  /// Devuelve `true` si hay un token guardado.
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
