part of 'expense_form_bloc.dart';

abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

class ExpenseFormSubmitRequested extends ExpenseFormEvent {
  final String? id;
  final double amount;
  final String description;
  final String categoryId;
  final String transactionDate;

  const ExpenseFormSubmitRequested({
    this.id,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.transactionDate,
  });

  @override
  List<Object?> get props => [
    id,
    amount,
    description,
    categoryId,
    transactionDate,
  ];
}

class ExpenseFormDeleteRequested extends ExpenseFormEvent {
  final String id;

  const ExpenseFormDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
