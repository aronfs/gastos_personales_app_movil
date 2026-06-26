import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';
import 'package:gastos_personales/layers/profile/domain/entity/profile_image.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile({required String firstName, required String lastName});
  Future<void> deactivateProfile({required String confirmation});

  Future<ProfileImage?> getProfileImage();
  Future<ProfileImage> uploadProfileImage(String filePath);
  Future<void> deleteProfileImage({required String confirmation});
}
