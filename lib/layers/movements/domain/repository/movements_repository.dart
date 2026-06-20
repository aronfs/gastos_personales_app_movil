import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

abstract class MovementsRepository {
  Future<List<Movement>> getMovements();
}
