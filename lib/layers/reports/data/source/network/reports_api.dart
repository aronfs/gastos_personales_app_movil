// ignore_for_file: use_null_aware_elements

import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/reports/data/dto/report_dto.dart';
import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class ReportsApi {
  Future<MonthlyReport> getMonthlyReport({int? year, int? month});
  Future<YearlyReport> getYearlyReport({int? year});
  Future<CategoriesReport> getCategoriesReport({
    String? startDate,
    String? endDate,
  });
}

class ReportsApiImpl implements ReportsApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<MonthlyReport> getMonthlyReport({int? year, int? month}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reportsMonth,
        queryParameters: {
          if (year != null) 'year': year,
          if (month != null) 'month': month,
        },
      );
      return MonthlyReportDto.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Monthly report error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<YearlyReport> getYearlyReport({int? year}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reportsYear,
        queryParameters: {if (year != null) 'year': year},
      );
      return YearlyReportDto.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Yearly report error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<CategoriesReport> getCategoriesReport({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reportsCategories,
        queryParameters: {
          if (startDate != null) 'startDate': startDate,
          if (endDate != null) 'endDate': endDate,
        },
      );
      return CategoriesReportDto.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Categories report error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
