import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/repository/reports_repository.dart';

class GetMonthlyReport {
  final ReportsRepository _repository;

  GetMonthlyReport(this._repository);

  Future<MonthlyReport> call({int? year, int? month}) =>
      _repository.getMonthlyReport(year: year, month: month);
}
