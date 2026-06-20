import 'package:gastos_personales/layers/dashboard/data/source/network/dashboard_api.dart';
import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';
import 'package:gastos_personales/layers/dashboard/domain/repository/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApi _api;

  DashboardRepositoryImpl(this._api);

  @override
  Future<DashboardSummary> getSummary() => _api.getSummary();
}
