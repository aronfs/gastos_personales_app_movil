part of 'incomes_bloc.dart';

abstract class IncomesState extends Equatable {
  const IncomesState();

  @override
  List<Object?> get props => [];
}

class IncomesInitial extends IncomesState {
  const IncomesInitial();
}

class IncomesLoading extends IncomesState {
  const IncomesLoading();
}

class IncomesLoaded extends IncomesState {
  final List<Movement> all;
  final List<Movement> filtered;
  final String selectedCategory;

  const IncomesLoaded({
    required this.all,
    required this.filtered,
    required this.selectedCategory,
  });

  double get monthlyTotal => filtered.fold(0.0, (sum, m) => sum + m.amount);

  List<String> get categories {
    final names = all.map((m) => m.category.name).toSet().toList()..sort();
    return ['Todos', ...names];
  }

  IncomesLoaded copyWith({
    List<Movement>? all,
    List<Movement>? filtered,
    String? selectedCategory,
  }) {
    return IncomesLoaded(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [all, filtered, selectedCategory];
}

class IncomesError extends IncomesState {
  final String message;

  const IncomesError(this.message);

  @override
  List<Object?> get props => [message];
}
