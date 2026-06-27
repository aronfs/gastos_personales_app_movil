import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object?> get props => [];
}

class EditProfileLoadRequested extends EditProfileEvent {
  const EditProfileLoadRequested();
}

class EditProfileFirstNameChanged extends EditProfileEvent {
  final String firstName;

  const EditProfileFirstNameChanged(this.firstName);

  @override
  List<Object?> get props => [firstName];
}

class EditProfileLastNameChanged extends EditProfileEvent {
  final String lastName;

  const EditProfileLastNameChanged(this.lastName);

  @override
  List<Object?> get props => [lastName];
}

class EditProfileSavePressed extends EditProfileEvent {
  const EditProfileSavePressed();
}

class EditProfileCancelPressed extends EditProfileEvent {
  const EditProfileCancelPressed();
}

class EditProfileAvatarChanged extends EditProfileEvent {
  final String filePath;

  const EditProfileAvatarChanged(this.filePath);

  @override
  List<Object?> get props => [filePath];
}
