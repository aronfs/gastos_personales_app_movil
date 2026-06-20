part of 'reports_bloc.dart';

/// Identifica qué periodo está activo en la UI.
enum ReportPeriodType { month, year }

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  final ReportPeriodType period;

  const ReportsLoading(this.period);

  @override
  List<Object?> get props => [period];
}

class ReportsMonthLoaded extends ReportsState {
  final MonthlyReport monthly;
  final CategoriesReport categories;

  const ReportsMonthLoaded({required this.monthly, required this.categories});

  @override
  List<Object?> get props => [monthly, categories];
}

class ReportsYearLoaded extends ReportsState {
  final YearlyReport yearly;
  final CategoriesReport categories;

  const ReportsYearLoaded({required this.yearly, required this.categories});

  @override
  List<Object?> get props => [yearly, categories];
}

class ReportsError extends ReportsState {
  final String message;
  final ReportPeriodType period;

  const ReportsError({required this.message, required this.period});

  @override
  List<Object?> get props => [message, period];
}
