import 'package:gastos_personales/layers/profile/domain/repository/profile_repository.dart';

class DeactivateProfile {
  final ProfileRepository repository;

  DeactivateProfile(this.repository);

  Future<void> call({required String confirmation}) {
    return repository.deactivateProfile(confirmation: confirmation);
  }
}
