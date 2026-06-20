part of 'expenses_bloc.dart';

abstract class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

class ExpensesFetchRequested extends ExpensesEvent {
  const ExpensesFetchRequested();
}

class ExpensesCategoryChanged extends ExpensesEvent {
  final String category;

  const ExpensesCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

class ExpensesSearchChanged extends ExpensesEvent {
  final String query;

  const ExpensesSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ExpensesDeleteRequested extends ExpensesEvent {
  final String id;

  const ExpensesDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
