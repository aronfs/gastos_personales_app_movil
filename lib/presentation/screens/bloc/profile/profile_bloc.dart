import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/delete_profile_image.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/get_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/update_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/upload_profile_image.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/profile/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UploadProfileImage _uploadProfileImage;
  final DeleteProfileImage _deleteProfileImage;

  ProfileBloc({
    required this._getProfile,
    required this._updateProfile,
    required this._uploadProfileImage,
    required this._deleteProfileImage,
  }) : super(const ProfileInitial()) {
    on<ProfileFetchRequested>(_onFetch);
    on<ProfileUpdateRequested>(_onUpdate);
    on<ProfileImageUploadRequested>(_onUploadImage);
    on<ProfileImageDeleteRequested>(_onDeleteImage);
  }

  Future<void> _onFetch(ProfileFetchRequested event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoading());
    try {
      final profile = await _getProfile();
      emit(ProfileLoaded(profile: profile));
    } catch (e) {
      emit(ProfileError(message: e.toString(), profile: null));
    }
  }

  Future<void> _onUpdate(ProfileUpdateRequested event, Emitter<ProfileState> emit) async {
    final currentState = state;
    final currentProfile = currentState is ProfileLoaded
        ? currentState.profile
        : (currentState is ProfileOperationLoading
            ? currentState.profile
            : null);

    if (currentProfile != null) {
      emit(ProfileOperationLoading(profile: currentProfile));
    }

    try {
      final profile = await _updateProfile(
        firstName: event.firstName,
        lastName: event.lastName,
      );
      emit(ProfileSuccess(
        message: 'Profile updated successfully',
        profile: profile,
      ));
    } catch (e) {
      emit(ProfileError(
        message: e.toString(),
        profile: currentProfile,
      ));
    }
  }

  Future<void> _onUploadImage(ProfileImageUploadRequested event, Emitter<ProfileState> emit) async {
    final currentState = state;
    final currentProfile = currentState is ProfileLoaded
        ? currentState.profile
        : (currentState is ProfileOperationLoading
            ? currentState.profile
            : null);

    if (currentProfile != null) {
      emit(ProfileOperationLoading(profile: currentProfile));
    }

    try {
      await _uploadProfileImage(event.filePath);
      final updatedProfile = currentProfile ?? await _getProfile();
      emit(ProfileSuccess(
        message: 'Profile image updated successfully',
        profile: updatedProfile,
      ));
    } catch (e) {
      emit(ProfileError(
        message: e.toString(),
        profile: currentProfile,
      ));
    }
  }

  Future<void> _onDeleteImage(ProfileImageDeleteRequested event, Emitter<ProfileState> emit) async {
    final currentState = state;
    final currentProfile = currentState is ProfileLoaded
        ? currentState.profile
        : (currentState is ProfileOperationLoading
            ? currentState.profile
            : null);

    if (currentProfile != null) {
      emit(ProfileOperationLoading(profile: currentProfile));
    }

    try {
      await _deleteProfileImage(confirmation: event.confirmation);
      final profile = await _getProfile();
      emit(ProfileSuccess(
        message: 'Profile image deleted successfully',
        profile: profile,
      ));
    } catch (e) {
      emit(ProfileError(
        message: e.toString(),
        profile: currentProfile,
      ));
    }
  }
}
