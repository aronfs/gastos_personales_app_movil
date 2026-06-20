import 'package:equatable/equatable.dart';

class Login with EquatableMixin {
  final String email;
  final String password;

  Login(this.email, this.password);

  @override
  List<Object> get props => [email, password];
} 
