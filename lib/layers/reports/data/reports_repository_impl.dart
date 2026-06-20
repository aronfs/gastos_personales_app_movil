import 'package:gastos_personales/layers/reports/data/source/network/reports_api.dart';
import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/repository/reports_repository.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsApi _api;

  ReportsRepositoryImpl(this._api);

  @override
  Future<MonthlyReport> getMonthlyReport({int? year, int? month}) =>
      _api.getMonthlyReport(year: year, month: month);

  @override
  Future<YearlyReport> getYearlyReport({int? year}) =>
      _api.getYearlyReport(year: year);

  @override
  Future<CategoriesReport> getCategoriesReport({
    String? startDate,
    String? endDate,
  }) => _api.getCategoriesReport(startDate: startDate, endDate: endDate);
}
