import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/create_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/delete_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/update_income.dart';

part 'income_form_event.dart';
part 'income_form_state.dart';

class IncomeFormBloc extends Bloc<IncomeFormEvent, IncomeFormState> {
  final CreateIncome _createIncome;
  final UpdateIncome _updateIncome;
  final DeleteIncome _deleteIncome;

  IncomeFormBloc(
    this._createIncome,
    this._updateIncome,
    this._deleteIncome,
  ) : super(const IncomeFormInitial()) {
    on<IncomeFormSubmitRequested>(_onSubmit);
    on<IncomeFormDeleteRequested>(_onDelete);
  }

  Future<void> _onSubmit(
    IncomeFormSubmitRequested event,
    Emitter<IncomeFormState> emit,
  ) async {
    emit(const IncomeFormLoading());
    try {
      if (event.id == null) {
        await _createIncome(
          amount: event.amount,
          description: event.description,
          categoryId: event.categoryId,
          transactionDate: event.transactionDate,
        );
      } else {
        await _updateIncome(
          id: event.id!,
          amount: event.amount,
          description: event.description,
          categoryId: event.categoryId,
          transactionDate: event.transactionDate,
        );
      }
      emit(const IncomeFormSuccess());
    } catch (e) {
      emit(IncomeFormFailure(_parseError(e)));
    }
  }

  Future<void> _onDelete(
    IncomeFormDeleteRequested event,
    Emitter<IncomeFormState> emit,
  ) async {
    emit(const IncomeFormLoading());
    try {
      await _deleteIncome(event.id);
      emit(const IncomeFormDeleted());
    } catch (e) {
      emit(IncomeFormFailure(_parseError(e)));
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
    return 'No se pudo guardar el ingreso. Intenta de nuevo.';
  }
}
