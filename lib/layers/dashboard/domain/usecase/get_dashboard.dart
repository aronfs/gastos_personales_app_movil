import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';
import 'package:gastos_personales/layers/dashboard/domain/repository/dashboard_repository.dart';

class GetDashboard {
  final DashboardRepository _repository;

  GetDashboard(this._repository);

  Future<DashboardSummary> call() => _repository.getSummary();
}
