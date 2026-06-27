import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';
import 'package:gastos_personales/layers/dashboard/data/dto/dashboard_dto.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class DashboardApi {
  Future<DashboardSummary> getSummary();
}

class DashboardApiImpl implements DashboardApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<DashboardSummary> getSummary() async {
    try {
      final response = await _dio.get(ApiEndpoints.dashboardSummary);
      return DashboardSummaryDto.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Dashboard error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
