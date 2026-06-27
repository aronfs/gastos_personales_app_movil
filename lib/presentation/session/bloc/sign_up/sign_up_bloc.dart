import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/register/domain/usecase/sign_up.dart';
import 'package:gastos_personales/util/token_storage.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUp _signUp;

  SignUpBloc({required this._signUp}) : super(const SignUpInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignUpReset>(_onSignUpReset);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignUpState> emit,
  ) async {
    emit(const SignUpLoading());
    try {
      final response = await _signUp(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
      );
      await TokenStorage.saveToken(response.accessToken);
      await TokenStorage.saveRefreshToken(response.refreshToken);
      await TokenStorage.saveUserId(response.userId);
      await TokenStorage.saveSessionId(response.sessionId);
      emit(const SignUpSuccess());
    } catch (e) {
      emit(SignUpFailure(error: _parseError(e)));
    }
  }

  void _onSignUpReset(SignUpReset event, Emitter<SignUpState> emit) {
    emit(const SignUpInitial());
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('409') || msg.contains('already exists')) {
      return 'El correo ya está registrado.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    if (msg.contains('400')) {
      return 'Datos inválidos. Verifica la información.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}
