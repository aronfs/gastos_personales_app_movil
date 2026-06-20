import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/login/domain/repository/login_repository.dart';
import 'package:gastos_personales/util/token_storage.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final LoginRepository loginRepository;

  SignInBloc({required this.loginRepository}) : super(const SignInInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignInReset>(_onSignInReset);
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<SignInState> emit,
  ) async {
    emit(const SignInLoading());
    try {
      final accesstoken = await loginRepository.login(
        event.email,
        event.password,
      );
      await TokenStorage.saveToken(accesstoken);
      emit(SignInSuccess(accesstoken: accesstoken));
    } catch (e) {
      emit(SignInFailure(error: _parseError(e)));
    }
  }

  void _onSignInReset(SignInReset event, Emitter<SignInState> emit) {
    emit(const SignInInitial());
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}
