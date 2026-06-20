part of 'incomes_bloc.dart';

abstract class IncomesEvent extends Equatable {
  const IncomesEvent();

  @override
  List<Object?> get props => [];
}

class IncomesFetchRequested extends IncomesEvent {
  const IncomesFetchRequested();
}

class IncomesCategoryChanged extends IncomesEvent {
  final String category;

  const IncomesCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class IncomesDeleteRequested extends IncomesEvent {
  final String id;

  const IncomesDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
