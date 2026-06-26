import 'package:gastos_personales/layers/profile/domain/repository/profile_repository.dart';

class DeleteProfileImage {
  final ProfileRepository repository;

  DeleteProfileImage(this.repository);

  Future<void> call({required String confirmation}) {
    return repository.deleteProfileImage(confirmation: confirmation);
  }
}
