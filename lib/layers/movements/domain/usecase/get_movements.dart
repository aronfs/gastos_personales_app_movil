import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/movements/domain/repository/movements_repository.dart';

class GetMovements {
  final MovementsRepository _repository;

  GetMovements(this._repository);

  Future<List<Movement>> call() => _repository.getMovements();
}
