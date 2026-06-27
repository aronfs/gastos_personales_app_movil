import 'package:equatable/equatable.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';

enum EditProfileStatus {
  initial,
  loading,
  loaded,
  saving,
  uploadingAvatar,
  success,
  error,
}

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final Profile? profile;
  final String firstName;
  final String lastName;
  final bool isDirty;
  final String? error;

  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.profile,
    this.firstName = '',
    this.lastName = '',
    this.isDirty = false,
    this.error,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    Profile? profile,
    String? firstName,
    String? lastName,
    bool? isDirty,
    String? error,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isDirty: isDirty ?? this.isDirty,
      error: error,
    );
  }

  bool get isValid =>
      firstName.trim().length >= 2 && lastName.trim().length >= 2;

  @override
  List<Object?> get props => [
    status,
    profile,
    firstName,
    lastName,
    isDirty,
    error,
  ];
}
