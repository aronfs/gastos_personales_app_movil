part of 'expense_form_bloc.dart';

abstract class ExpenseFormState extends Equatable {
  const ExpenseFormState();

  @override
  List<Object?> get props => [];
}

class ExpenseFormInitial extends ExpenseFormState {
  const ExpenseFormInitial();
}

class ExpenseFormLoading extends ExpenseFormState {
  const ExpenseFormLoading();
}

class ExpenseFormSuccess extends ExpenseFormState {
  const ExpenseFormSuccess();
}

class ExpenseFormDeleted extends ExpenseFormState {
  const ExpenseFormDeleted();
}

class ExpenseFormFailure extends ExpenseFormState {
  final String message;

  const ExpenseFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
