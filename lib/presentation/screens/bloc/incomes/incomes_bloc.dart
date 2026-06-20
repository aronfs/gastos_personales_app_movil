import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/delete_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/get_incomes.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

part 'incomes_event.dart';
part 'incomes_state.dart';

class IncomesBloc extends Bloc<IncomesEvent, IncomesState> {
  final GetIncomes _getIncomes;
  final DeleteIncome _deleteIncome;

  IncomesBloc(this._getIncomes, this._deleteIncome)
    : super(const IncomesInitial()) {
    on<IncomesFetchRequested>(_onFetch);
    on<IncomesCategoryChanged>(_onCategoryChanged);
    on<IncomesDeleteRequested>(_onDelete);
  }

  Future<void> _onFetch(
    IncomesFetchRequested event,
    Emitter<IncomesState> emit,
  ) async {
    emit(const IncomesLoading());
    try {
      final incomes = await _getIncomes();
      emit(
        IncomesLoaded(
          all: incomes,
          filtered: incomes,
          selectedCategory: 'Todos',
        ),
      );
    } catch (e) {
      emit(IncomesError(_parseError(e)));
    }
  }

  void _onCategoryChanged(
    IncomesCategoryChanged event,
    Emitter<IncomesState> emit,
  ) {
    final current = state;
    if (current is! IncomesLoaded) return;

    emit(
      current.copyWith(
        selectedCategory: event.category,
        filtered: _applyFilter(current.all, event.category),
      ),
    );
  }

  Future<void> _onDelete(
    IncomesDeleteRequested event,
    Emitter<IncomesState> emit,
  ) async {
    final current = state;
    if (current is! IncomesLoaded) return;

    try {
      await _deleteIncome(event.id);
      final updated = current.all.where((i) => i.id != event.id).toList();
      emit(
        current.copyWith(
          all: updated,
          filtered: _applyFilter(updated, current.selectedCategory),
        ),
      );
    } catch (e) {
      emit(IncomesError(_parseError(e)));
    }
  }

  List<Movement> _applyFilter(List<Movement> all, String category) {
    if (category == 'Todos') return all;
    return all.where((m) => m.category.name == category).toList();
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'No se pudieron cargar los ingresos. Intenta de nuevo.';
  }
}
