import 'package:gastos_personales/layers/movements/data/source/network/movements_api.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/movements/domain/repository/movements_repository.dart';

class MovementsRepositoryImpl implements MovementsRepository {
  final MovementsApi _api;

  MovementsRepositoryImpl(this._api);

  @override
  Future<List<Movement>> getMovements() => _api.getMovements();
}
