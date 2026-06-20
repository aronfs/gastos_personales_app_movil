import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/create_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/delete_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/update_expense.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  final CreateExpense _createExpense;
  final UpdateExpense _updateExpense;
  final DeleteExpense _deleteExpense;

  ExpenseFormBloc(
    this._createExpense,
    this._updateExpense,
    this._deleteExpense,
  ) : super(const ExpenseFormInitial()) {
    on<ExpenseFormSubmitRequested>(_onSubmit);
    on<ExpenseFormDeleteRequested>(_onDelete);
  }

  Future<void> _onSubmit(
    ExpenseFormSubmitRequested event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(const ExpenseFormLoading());
    try {
      if (event.id == null) {
        await _createExpense(
          amount: event.amount,
          description: event.description,
          categoryId: event.categoryId,
          transactionDate: event.transactionDate,
        );
      } else {
        await _updateExpense(
          id: event.id!,
          amount: event.amount,
          description: event.description,
          categoryId: event.categoryId,
          transactionDate: event.transactionDate,
        );
      }
      emit(const ExpenseFormSuccess());
    } catch (e) {
      emit(ExpenseFormFailure(_parseError(e)));
    }
  }

  Future<void> _onDelete(
    ExpenseFormDeleteRequested event,
    Emitter<ExpenseFormState> emit,
  ) async {
    emit(const ExpenseFormLoading());
    try {
      await _deleteExpense(event.id);
      emit(const ExpenseFormDeleted());
    } catch (e) {
      emit(ExpenseFormFailure(_parseError(e)));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'No se pudo guardar el gasto. Intenta de nuevo.';
  }
}
