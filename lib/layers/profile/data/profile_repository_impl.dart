import 'package:gastos_personales/layers/profile/data/dto/profile_dto.dart';
import 'package:gastos_personales/layers/profile/data/dto/profile_image_dto.dart';
import 'package:gastos_personales/layers/profile/data/source/network/profile_api.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile_image.dart';
import 'package:gastos_personales/layers/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi _api;

  ProfileRepositoryImpl(this._api);

  @override
  Future<Profile> getProfile() async {
    final json = await _api.getProfile();
    return ProfileDto.fromMap(json);
  }

  @override
  Future<Profile> updateProfile({required String firstName, required String lastName}) async {
    final json = await _api.updateProfile(firstName, lastName);
    return ProfileDto.fromMap(json);
  }

  @override
  Future<void> deactivateProfile({required String confirmation}) async {
    await _api.deactivateProfile(confirmation);
  }

  @override
  Future<ProfileImage?> getProfileImage() async {
    try {
      final json = await _api.getProfileImageMetadata();
      return ProfileImageDto.fromMap(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ProfileImage> uploadProfileImage(String filePath) async {
    final json = await _api.uploadProfileImage(filePath);
    return ProfileImageDto.fromMap(json);
  }

  @override
  Future<void> deleteProfileImage({required String confirmation}) async {
    await _api.deleteProfileImage(confirmation);
  }
}
