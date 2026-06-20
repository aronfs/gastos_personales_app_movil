part of 'product_form_bloc.dart';

abstract class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

class ProductFormSubmitRequested extends ProductFormEvent {
  final String categoryId;
  final String name;
  final String description;
  final double unitPrice;

  const ProductFormSubmitRequested({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [categoryId, name, description, unitPrice];
}
