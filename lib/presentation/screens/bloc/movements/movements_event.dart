part of 'movements_bloc.dart';

abstract class MovementsEvent extends Equatable {
  const MovementsEvent();

  @override
  List<Object?> get props => [];
}

/// Carga la lista de movimientos desde la API.
class MovementsFetchRequested extends MovementsEvent {
  const MovementsFetchRequested();
}

/// Filtra por categoría — opera sobre la lista ya cargada (sin llamada extra).
class MovementsCategoryChanged extends MovementsEvent {
  final String category;

  const MovementsCategoryChanged(this.category);

  @override
  List<Object?> get props => [category];
}

/// Filtra por búsqueda de texto — opera sobre la lista ya cargada.
class MovementsSearchChanged extends MovementsEvent {
  final String query;

  const MovementsSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}
