import 'dart:async';
import 'package:gastos_personales/util/token_storage.dart';

class SessionManager {
  SessionManager._();

  static final SessionManager _instance = SessionManager._();
  factory SessionManager() => _instance;

  final StreamController<void> _sessionExpiredController =
      StreamController<void>.broadcast();

  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  bool _isLoggingOut = false;

  bool get isLoggingOut => _isLoggingOut;

  Future<void> logout({bool preserveBiometric = false}) async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await TokenStorage.clearSession(
        preserveBiometricLogin: preserveBiometric,
      );

      _sessionExpiredController.add(null);
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<void> forceLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await TokenStorage.clearAll();

      _sessionExpiredController.add(null);
    } finally {
      _isLoggingOut = false;
    }
  }

  void dispose() {
    _sessionExpiredController.close();
  }
}
