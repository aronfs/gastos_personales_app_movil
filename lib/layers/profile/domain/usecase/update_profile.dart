import 'package:gastos_personales/layers/profile/domain/entity/profile.dart';
import 'package:gastos_personales/layers/profile/domain/repository/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Profile> call({required String firstName, required String lastName}) {
    return repository.updateProfile(firstName: firstName, lastName: lastName);
  }
}
