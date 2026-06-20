part of 'expenses_bloc.dart';

abstract class ExpensesState extends Equatable {
  const ExpensesState();

  @override
  List<Object?> get props => [];
}

class ExpensesInitial extends ExpensesState {
  const ExpensesInitial();
}

class ExpensesLoading extends ExpensesState {
  const ExpensesLoading();
}

class ExpensesLoaded extends ExpensesState {
  final List<Movement> all;
  final List<Movement> filtered;
  final String selectedCategory;
  final String searchQuery;

  const ExpensesLoaded({
    required this.all,
    required this.filtered,
    required this.selectedCategory,
    required this.searchQuery,
  });

  double get totalFiltered =>
      filtered.fold(0.0, (sum, m) => sum + m.amount);

  List<String> get categories {
    final names = all.map((m) => m.category.name).toSet().toList()..sort();
    return ['Todos', ...names];
  }

  ExpensesLoaded copyWith({
    List<Movement>? all,
    List<Movement>? filtered,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ExpensesLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [all, filtered, selectedCategory, searchQuery];
}

class ExpensesError extends ExpensesState {
  final String message;

  const ExpensesError(this.message);

  @override
  List<Object?> get props => [message];
}
