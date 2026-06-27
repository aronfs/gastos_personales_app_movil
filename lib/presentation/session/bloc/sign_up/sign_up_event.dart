part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRequested extends SignUpEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const SignUpRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class SignUpReset extends SignUpEvent {
  const SignUpReset();
}
