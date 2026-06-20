import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/products/domain/usecase/create_product.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  final CreateProduct _createProduct;

  ProductFormBloc(this._createProduct) : super(ProductFormInitial()) {
    on<ProductFormSubmitRequested>(_onSubmit);
  }

  Future<void> _onSubmit(
    ProductFormSubmitRequested event,
    Emitter<ProductFormState> emit,
  ) async {
    emit(ProductFormLoading());
    try {
      await _createProduct(
        categoryId: event.categoryId,
        name: event.name,
        description: event.description,
        unitPrice: event.unitPrice,
      );
      emit(ProductFormSuccess());
    } catch (e) {
      emit(ProductFormFailure(e.toString()));
    }
  }
}
