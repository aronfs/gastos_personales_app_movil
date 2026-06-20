part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial / limpio.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Petición en curso — mostrar indicador de carga.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login exitoso — contiene el access token.
class LoginSuccess extends LoginState {
  final String accessToken;

  const LoginSuccess(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}

/// Error durante el login.
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
