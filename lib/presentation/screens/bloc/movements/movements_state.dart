part of 'movements_bloc.dart';

abstract class MovementsState extends Equatable {
  const MovementsState();

  @override
  List<Object?> get props => [];
}

class MovementsInitial extends MovementsState {
  const MovementsInitial();
}

class MovementsLoading extends MovementsState {
  const MovementsLoading();
}

class MovementsLoaded extends MovementsState {
  /// Lista completa sin filtros.
  final List<Movement> all;

  /// Lista filtrada (categoría + búsqueda) — la que se muestra en la UI.
  final List<Movement> filtered;

  final String selectedCategory;
  final String searchQuery;

  const MovementsLoaded({
    required this.all,
    required this.filtered,
    required this.selectedCategory,
    required this.searchQuery,
  });

  double get totalFiltered => filtered.fold(
    0.0,
    (sum, m) => sum + (m.isExpense ? -m.amount : m.amount),
  );

  /// Categorías únicas extraídas de la lista + "Todos".
  List<String> get categories {
    final names = all.map((m) => m.category.name).toSet().toList()..sort();
    return ['Todos', ...names];
  }

  MovementsLoaded copyWith({
    List<Movement>? all,
    List<Movement>? filtered,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return MovementsLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [filtered, selectedCategory, searchQuery];
}

class MovementsError extends MovementsState {
  final String message;

  const MovementsError(this.message);

  @override
  List<Object?> get props => [message];
}
