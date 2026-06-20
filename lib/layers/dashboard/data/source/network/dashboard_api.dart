import 'package:dio/dio.dart';
import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';
import 'package:gastos_personales/layers/dashboard/data/dto/dashboard_dto.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

abstract class DashboardApi {
  Future<DashboardSummary> getSummary();
}

class DashboardApiImpl implements DashboardApi {
  final Dio _dio = Dio();

  @override
  Future<DashboardSummary> getSummary() async {
    final token = await TokenStorage.getToken();

    try {
      final response = await _dio.get(
        ApiEndpoints.dashboardSummary,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return DashboardSummaryDto.fromMap(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception(
        'Dashboard error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
