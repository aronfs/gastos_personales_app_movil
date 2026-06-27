import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/get_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/update_profile.dart';
import 'package:gastos_personales/layers/profile/domain/usecase/upload_profile_image.dart';
import 'package:gastos_personales/presentation/screens/bloc/edit_profile/edit_profile_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/edit_profile/edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final UploadProfileImage uploadProfileImage;

  EditProfileBloc({
    required this.getProfile,
    required this.updateProfile,
    required this.uploadProfileImage,
  }) : super(const EditProfileState()) {
    on<EditProfileLoadRequested>(_onLoad);
    on<EditProfileFirstNameChanged>(_onFirstNameChanged);
    on<EditProfileLastNameChanged>(_onLastNameChanged);
    on<EditProfileAvatarChanged>(_onAvatarChanged);
    on<EditProfileSavePressed>(_onSave);
    on<EditProfileCancelPressed>(_onCancel);
  }

  Future<void> _onLoad(
    EditProfileLoadRequested event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EditProfileStatus.loading));
    try {
      final profile = await getProfile();
      emit(
        EditProfileState(
          status: EditProfileStatus.loaded,
          profile: profile,
          firstName: profile.firstName,
          lastName: profile.lastName,
          isDirty: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: EditProfileStatus.error, error: e.toString()),
      );
    }
  }

  void _onFirstNameChanged(
    EditProfileFirstNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        firstName: event.firstName,
        isDirty: _isDirty(firstName: event.firstName),
      ),
    );
  }

  void _onLastNameChanged(
    EditProfileLastNameChanged event,
    Emitter<EditProfileState> emit,
  ) {
    emit(
      state.copyWith(
        lastName: event.lastName,
        isDirty: _isDirty(lastName: event.lastName),
      ),
    );
  }

  Future<void> _onAvatarChanged(
    EditProfileAvatarChanged event,
    Emitter<EditProfileState> emit,
  ) async {
    emit(state.copyWith(status: EditProfileStatus.uploadingAvatar));
    try {
      await uploadProfileImage(event.filePath);
      emit(state.copyWith(status: EditProfileStatus.loaded));
    } catch (e) {
      emit(
        state.copyWith(status: EditProfileStatus.loaded, error: e.toString()),
      );
    }
  }

  Future<void> _onSave(
    EditProfileSavePressed event,
    Emitter<EditProfileState> emit,
  ) async {
    if (!state.isValid) return;
    emit(state.copyWith(status: EditProfileStatus.saving));
    try {
      final profile = await updateProfile(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
      );
      emit(
        EditProfileState(
          status: EditProfileStatus.success,
          profile: profile,
          firstName: profile.firstName,
          lastName: profile.lastName,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: EditProfileStatus.error, error: e.toString()),
      );
    }
  }

  void _onCancel(
    EditProfileCancelPressed event,
    Emitter<EditProfileState> emit,
  ) {
    // UI handles navigation; no state change needed.
  }

  bool _isDirty({String? firstName, String? lastName}) {
    final profile = state.profile;
    if (profile == null) return false;
    return (firstName ?? state.firstName) != profile.firstName ||
        (lastName ?? state.lastName) != profile.lastName;
  }
}
