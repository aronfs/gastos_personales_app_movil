part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Solicita cargar el resumen del dashboard.
class DashboardFetchRequested extends DashboardEvent {
  const DashboardFetchRequested();
}
