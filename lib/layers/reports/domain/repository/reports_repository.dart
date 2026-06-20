import 'package:gastos_personales/layers/reports/domain/entity/report.dart';

abstract class ReportsRepository {
  Future<MonthlyReport> getMonthlyReport({int? year, int? month});
  Future<YearlyReport> getYearlyReport({int? year});
  Future<CategoriesReport> getCategoriesReport({
    String? startDate,
    String? endDate,
  });
}
