import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/repository/reports_repository.dart';

class GetCategoriesReport {
  final ReportsRepository _repository;

  GetCategoriesReport(this._repository);

  Future<CategoriesReport> call({String? startDate, String? endDate}) =>
      _repository.getCategoriesReport(startDate: startDate, endDate: endDate);
}
