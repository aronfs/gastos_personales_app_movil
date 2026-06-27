import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_categories_report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_monthly_report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_yearly_report.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final GetMonthlyReport _getMonthly;
  final GetYearlyReport _getYearly;
  final GetCategoriesReport _getCategories;

  ReportsBloc({
    required this._getMonthly,
    required this._getYearly,
    required this._getCategories,
  }) : super(const ReportsInitial()) {
    on<ReportsFetchRequested>(_onFetch);
    on<ReportsPeriodChanged>(_onPeriodChanged);
  }

  Future<void> _onFetch(
    ReportsFetchRequested event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportsLoading(event.period));
    try {
      if (event.period == ReportPeriodType.month) {
        // Las dos llamadas en paralelo
        final results = await Future.wait([_getMonthly(), _getCategories()]);
        emit(
          ReportsMonthLoaded(
            monthly: results[0] as MonthlyReport,
            categories: results[1] as CategoriesReport,
          ),
        );
      } else {
        final results = await Future.wait([_getYearly(), _getCategories()]);
        emit(
          ReportsYearLoaded(
            yearly: results[0] as YearlyReport,
            categories: results[1] as CategoriesReport,
          ),
        );
      }
    } catch (e) {
      emit(ReportsError(message: _parseError(e), period: event.period));
    }
  }

  void _onPeriodChanged(
    ReportsPeriodChanged event,
    Emitter<ReportsState> emit,
  ) {
    add(ReportsFetchRequested(event.period));
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'No se pudieron cargar los reportes. Intenta de nuevo.';
  }
}
