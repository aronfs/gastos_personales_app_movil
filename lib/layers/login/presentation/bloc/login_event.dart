part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Dispara el proceso de sign-in.
class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Resetea el bloc al estado inicial (ej. al volver a la pantalla).
class LoginReset extends LoginEvent {
  const LoginReset();
}
