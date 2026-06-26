import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboard _getDashboard;
  final Dio _dio;

  DashboardBloc(this._getDashboard, {Dio? dio})
      : _dio = dio ?? Dio(),
        super(const DashboardInitial()) {
    on<DashboardFetchRequested>(_onFetch);
  }

  Future<void> _onFetch(
    DashboardFetchRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final results = await Future.wait([
        _getDashboard(),
        _fetchUserName(),
      ]);
      final summary = results[0] as DashboardSummary;
      final userName = results[1] as String;
      emit(DashboardLoaded(summary, userName: userName));
    } catch (e) {
      emit(DashboardError(_parseError(e)));
    }
  }

  Future<String> _fetchUserName() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get(
        ApiEndpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final first = (data['first_name'] as String?) ?? '';
      final last = (data['last_name'] as String?) ?? '';
      return '$first $last';
    } catch (_) {
      return '';
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'No se pudo cargar el dashboard. Intenta de nuevo.';
  }
}
