part of 'product_form_bloc.dart';

abstract class ProductFormState extends Equatable {
  const ProductFormState();

  @override
  List<Object?> get props => [];
}

class ProductFormInitial extends ProductFormState {}

class ProductFormLoading extends ProductFormState {}

class ProductFormSuccess extends ProductFormState {}

class ProductFormFailure extends ProductFormState {
  final String message;

  const ProductFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
