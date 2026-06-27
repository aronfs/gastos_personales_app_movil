import 'dart:convert';

class RegisterDto {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterDto({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      };

  String toJson() => json.encode(toMap());
}
