import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary();
}
