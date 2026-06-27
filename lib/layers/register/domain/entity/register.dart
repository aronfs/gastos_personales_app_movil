import 'package:equatable/equatable.dart';

class Register with EquatableMixin {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  Register({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [email, password, firstName, lastName];
}
