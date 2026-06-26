import 'package:equatable/equatable.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final Profile profile;

  const ProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileOperationLoading extends ProfileState {
  final Profile profile;

  const ProfileOperationLoading({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileSuccess extends ProfileState {
  final String message;
  final Profile? profile;

  const ProfileSuccess({required this.message, this.profile});

  @override
  List<Object?> get props => [message, profile];
}

class ProfileError extends ProfileState {
  final String message;
  final Profile? profile;

  const ProfileError({required this.message, this.profile});

  @override
  List<Object?> get props => [message, profile];
}
