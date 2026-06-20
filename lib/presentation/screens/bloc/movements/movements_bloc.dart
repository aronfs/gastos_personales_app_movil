import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/movements/domain/usecase/get_movements.dart';

part 'movements_event.dart';
part 'movements_state.dart';

class MovementsBloc extends Bloc<MovementsEvent, MovementsState> {
  final GetMovements _getMovements;

  MovementsBloc(this._getMovements) : super(const MovementsInitial()) {
    on<MovementsFetchRequested>(_onFetch);
    on<MovementsCategoryChanged>(_onCategoryChanged);
    on<MovementsSearchChanged>(_onSearchChanged);
  }

  Future<void> _onFetch(
    MovementsFetchRequested event,
    Emitter<MovementsState> emit,
  ) async {
    emit(const MovementsLoading());
    try {
      final movements = await _getMovements();
      emit(
        MovementsLoaded(
          all: movements,
          filtered: movements,
          selectedCategory: 'Todos',
          searchQuery: '',
        ),
      );
    } catch (e) {
      emit(MovementsError(_parseError(e)));
    }
  }

  void _onCategoryChanged(
    MovementsCategoryChanged event,
    Emitter<MovementsState> emit,
  ) {
    final current = state;
    if (current is! MovementsLoaded) return;

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
    MovementsSearchChanged event,
    Emitter<MovementsState> emit,
  ) {
    final current = state;
    if (current is! MovementsLoaded) return;

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
    return 'No se pudieron cargar los movimientos. Intenta de nuevo.';
  }
}
