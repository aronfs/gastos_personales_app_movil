import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/delete_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/get_expenses.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  final GetExpenses _getExpenses;
  final DeleteExpense _deleteExpense;

  ExpensesBloc(this._getExpenses, this._deleteExpense)
    : super(const ExpensesInitial()) {
    on<ExpensesFetchRequested>(_onFetch);
    on<ExpensesCategoryChanged>(_onCategoryChanged);
    on<ExpensesSearchChanged>(_onSearchChanged);
    on<ExpensesDeleteRequested>(_onDelete);
  }

  Future<void> _onFetch(
    ExpensesFetchRequested event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(const ExpensesLoading());
    try {
      final expenses = await _getExpenses();
      emit(
        ExpensesLoaded(
          all: expenses,
          filtered: expenses,
          selectedCategory: 'Todos',
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(ExpensesError(_parseError(e)));
    }
  }

  void _onCategoryChanged(
    ExpensesCategoryChanged event,
    Emitter<ExpensesState> emit,
  ) {
    final current = state;
    if (current is! ExpensesLoaded) return;

    emit(
      current.copyWith(
        selectedCategory: event.category,
        filtered: _applyFilters(
          current.all,
          category: event.category,
          query: current.searchQuery,
        ),
      ),
    );
  }

  void _onSearchChanged(
    ExpensesSearchChanged event,
    Emitter<ExpensesState> emit,
  ) {
    final current = state;
    if (current is! ExpensesLoaded) return;

    emit(
      current.copyWith(
        searchQuery: event.query,
        filtered: _applyFilters(
          current.all,
          category: current.selectedCategory,
          query: event.query,
        ),
      ),
    );
  }

  Future<void> _onDelete(
    ExpensesDeleteRequested event,
    Emitter<ExpensesState> emit,
  ) async {
    final current = state;
    if (current is! ExpensesLoaded) return;

    try {
      await _deleteExpense(event.id);
      final updated = current.all.where((e) => e.id != event.id).toList();
      emit(
        current.copyWith(
          all: updated,
          filtered: _applyFilters(
            updated,
            category: current.selectedCategory,
            query: current.searchQuery,
          ),
        ),
      );
    } catch (e) {
      emit(ExpensesError(_parseError(e)));
    }
  }

  List<Movement> _applyFilters(
    List<Movement> all, {
    required String category,
    required String query,
  }) {
    return all.where((m) {
      final matchCat = category == 'Todos' || m.category.name == category;
      final matchSearch =
          query.isEmpty ||
          m.description.toLowerCase().contains(query.toLowerCase()) ||
          m.category.name.toLowerCase().contains(query.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('401') || msg.contains('Unauthorized')) {
      return 'Sesión expirada. Inicia sesión de nuevo.';
    }
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'Sin conexión a internet.';
    }
    return 'No se pudieron cargar los gastos. Intenta de nuevo.';
  }
}
