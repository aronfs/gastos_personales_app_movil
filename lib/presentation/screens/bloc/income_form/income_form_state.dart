part of 'income_form_bloc.dart';

abstract class IncomeFormState extends Equatable {
  const IncomeFormState();

  @override
  List<Object?> get props => [];
}

class IncomeFormInitial extends IncomeFormState {
  const IncomeFormInitial();
}

class IncomeFormLoading extends IncomeFormState {
  const IncomeFormLoading();
}

class IncomeFormSuccess extends IncomeFormState {
  const IncomeFormSuccess();
}

class IncomeFormDeleted extends IncomeFormState {
  const IncomeFormDeleted();
}

class IncomeFormFailure extends IncomeFormState {
  final String message;

  const IncomeFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
