import 'package:gastos_personales/layers/profile/domain/entity/profile_image.dart';
import 'package:gastos_personales/layers/profile/domain/repository/profile_repository.dart';

class UploadProfileImage {
  final ProfileRepository repository;

  UploadProfileImage(this.repository);

  Future<ProfileImage> call(String filePath) {
    return repository.uploadProfileImage(filePath);
  }
}
