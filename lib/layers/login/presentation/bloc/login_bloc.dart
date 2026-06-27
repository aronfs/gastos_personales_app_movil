import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/login/domain/usecase/sign_in.dart';
import 'package:gastos_personales/util/token_storage.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SignIn _signIn;

  LoginBloc({required this._signIn})
    : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    try {
      final response = await _signIn(event.email, event.password);
      await TokenStorage.saveToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveUserId(response.userId);
      await TokenStorage.saveSessionId(response.sessionId);
      emit(LoginSuccess(response.accessToken));
    } catch (e) {
      debugPrint(e.toString());
      emit(LoginFailure(_parseError(e)));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
  }

  /// Convierte una excepción en un mensaje legible.
  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    debugPrint(msg);
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}
