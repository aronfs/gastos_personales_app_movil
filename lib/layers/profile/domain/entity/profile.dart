import 'package:equatable/equatable.dart';
import 'profile_image.dart';

class Profile with EquatableMixin {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final bool active;
  final List<String> roles;
  final ProfileImage? profileImage;

  Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.active,
    required this.roles,
    this.profileImage,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, active, roles, profileImage];
}
