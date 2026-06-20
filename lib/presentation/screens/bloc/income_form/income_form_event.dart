part of 'income_form_bloc.dart';

abstract class IncomeFormEvent extends Equatable {
  const IncomeFormEvent();

  @override
  List<Object?> get props => [];
}

class IncomeFormSubmitRequested extends IncomeFormEvent {
  final String? id;
  final double amount;
  final String description;
  final String categoryId;
  final String transactionDate;

  const IncomeFormSubmitRequested({
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

class IncomeFormDeleteRequested extends IncomeFormEvent {
  final String id;

  const IncomeFormDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
