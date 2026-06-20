part of 'reports_bloc.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

/// Carga los tres reportes según el periodo seleccionado.
class ReportsFetchRequested extends ReportsEvent {
  final ReportPeriodType period;

  const ReportsFetchRequested(this.period);

  @override
  List<Object?> get props => [period];
}

/// El usuario cambia el tab de periodo (mes / año).
class ReportsPeriodChanged extends ReportsEvent {
  final ReportPeriodType period;

  const ReportsPeriodChanged(this.period);

  @override
  List<Object?> get props => [period];
}
