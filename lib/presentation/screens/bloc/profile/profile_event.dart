import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileFetchRequested extends ProfileEvent {
  const ProfileFetchRequested();
}

class ProfileUpdateRequested extends ProfileEvent {
  final String firstName;
  final String lastName;

  const ProfileUpdateRequested({required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];
}

class ProfileDeactivateRequested extends ProfileEvent {
  final String confirmation;

  const ProfileDeactivateRequested({required this.confirmation});

  @override
  List<Object?> get props => [confirmation];
}

class ProfileImageUploadRequested extends ProfileEvent {
  final String filePath;

  const ProfileImageUploadRequested({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class ProfileImageDeleteRequested extends ProfileEvent {
  final String confirmation;

  const ProfileImageDeleteRequested({required this.confirmation});

  @override
  List<Object?> get props => [confirmation];
}
