import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/repository/reports_repository.dart';

class GetYearlyReport {
  final ReportsRepository _repository;

  GetYearlyReport(this._repository);

  Future<YearlyReport> call({int? year}) =>
      _repository.getYearlyReport(year: year);
}
