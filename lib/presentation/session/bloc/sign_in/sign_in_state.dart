part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial / limpio.
class SignInInitial extends SignInState {
  const SignInInitial();
}

/// Petición en curso.
class SignInLoading extends SignInState {
  const SignInLoading();
}

/// Login exitoso — contiene el access token.
class SignInSuccess extends SignInState {
  final String accesstoken;

  const SignInSuccess({required this.accesstoken});

  @override
  List<Object?> get props => [accesstoken];
}

/// Error durante el login.
class SignInFailure extends SignInState {
  final String error;

  const SignInFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
