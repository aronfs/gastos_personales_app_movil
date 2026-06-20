part of 'supermarket_form_bloc.dart';

abstract class SupermarketFormEvent extends Equatable {
  const SupermarketFormEvent();

  @override
  List<Object?> get props => [];
}

class SupermarketFormFetchRequested extends SupermarketFormEvent {}

class SupermarketFormCategorySelected extends SupermarketFormEvent {
  final Category category;

  const SupermarketFormCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class SupermarketFormProductAdded extends SupermarketFormEvent {
  final Product product;
  final int quantity;

  const SupermarketFormProductAdded(this.product, this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}

class SupermarketFormProductUpdated extends SupermarketFormEvent {
  final int index;
  final int quantity;

  const SupermarketFormProductUpdated(this.index, this.quantity);

  @override
  List<Object?> get props => [index, quantity];
}

class SupermarketFormProductRemoved extends SupermarketFormEvent {
  final int index;

  const SupermarketFormProductRemoved(this.index);

  @override
  List<Object?> get props => [index];
}

class SupermarketFormSubmitRequested extends SupermarketFormEvent {
  final String description;
  final String transactionDate;

  const SupermarketFormSubmitRequested({
    required this.description,
    required this.transactionDate,
  });

  @override
  List<Object?> get props => [description, transactionDate];
}
