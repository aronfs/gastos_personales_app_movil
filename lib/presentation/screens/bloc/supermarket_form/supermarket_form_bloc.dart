import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/create_supermarket_expense.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/domain/usecase/get_products.dart';

part 'supermarket_form_event.dart';
part 'supermarket_form_state.dart';

class SupermarketFormBloc extends Bloc<SupermarketFormEvent, SupermarketFormState> {
  final GetCategories _getCategories;
  final GetProducts _getProducts;
  final CreateSupermarketExpense _createSupermarketExpense;
  final GetDashboard _getDashboard;

  SupermarketFormBloc(
    this._getCategories,
    this._getProducts,
    this._createSupermarketExpense,
    this._getDashboard,
  ) : super(SupermarketFormInitial()) {
    on<SupermarketFormFetchRequested>(_onFetchRequested);
    on<SupermarketFormCategorySelected>(_onCategorySelected);
    on<SupermarketFormProductAdded>(_onProductAdded);
    on<SupermarketFormProductUpdated>(_onProductUpdated);
    on<SupermarketFormProductRemoved>(_onProductRemoved);
    on<SupermarketFormSubmitRequested>(_onSubmitRequested);
  }

  Future<void> _onFetchRequested(
    SupermarketFormFetchRequested event,
    Emitter<SupermarketFormState> emit,
  ) async {
    final currentState = state is SupermarketFormLoaded ? state as SupermarketFormLoaded : null;
    emit(SupermarketFormLoading());
    try {
      final categories = await _getCategories(type: CategoryType.expense);
      Category? defaultCategory;
      if (currentState?.selectedCategory != null) {
        // Find the updated category reference matching the selected one
        defaultCategory = categories.cast<Category?>().firstWhere(
            (c) => c?.id == currentState!.selectedCategory!.id,
            orElse: () => currentState!.selectedCategory);
      } else if (categories.isNotEmpty) {
        defaultCategory = categories.cast<Category?>().firstWhere(
            (c) => c!.name.toLowerCase().contains('supermercado'),
            orElse: () => categories.first);
      }
      
      final products = await _getProducts(categoryId: defaultCategory?.id);
      
      final dashboard = await _getDashboard();

      emit(SupermarketFormLoaded(
        categories: categories,
        selectedCategory: defaultCategory,
        availableProducts: products,
        cart: currentState?.cart ?? const [],
        baseCupo: dashboard.currentBalance,
      ));
    } catch (e) {
      emit(SupermarketFormFailure(e.toString()));
      if (currentState != null) emit(currentState);
    }
  }

  Future<void> _onCategorySelected(
    SupermarketFormCategorySelected event,
    Emitter<SupermarketFormState> emit,
  ) async {
    if (state is SupermarketFormLoaded) {
      final currentState = state as SupermarketFormLoaded;
      emit(SupermarketFormLoading());
      try {
        final products = await _getProducts(categoryId: event.category.id);
        emit(currentState.copyWith(
          selectedCategory: event.category,
          availableProducts: products,
        ));
      } catch (e) {
        emit(SupermarketFormFailure(e.toString()));
        emit(currentState);
      }
    }
  }

  void _onProductAdded(
    SupermarketFormProductAdded event,
    Emitter<SupermarketFormState> emit,
  ) {
    if (state is SupermarketFormLoaded) {
      final currentState = state as SupermarketFormLoaded;
      final newCart = List<CartItem>.from(currentState.cart);
      
      final existingIndex = newCart.indexWhere((c) => c.product.id == event.product.id);
      if (existingIndex >= 0) {
        newCart[existingIndex] = newCart[existingIndex].copyWith(
          quantity: newCart[existingIndex].quantity + event.quantity,
        );
      } else {
        newCart.add(CartItem(event.product, event.quantity));
      }

      emit(currentState.copyWith(cart: newCart));
    }
  }

  void _onProductUpdated(
    SupermarketFormProductUpdated event,
    Emitter<SupermarketFormState> emit,
  ) {
    if (state is SupermarketFormLoaded) {
      final currentState = state as SupermarketFormLoaded;
      if (event.index >= 0 && event.index < currentState.cart.length) {
        final newCart = List<CartItem>.from(currentState.cart);
        newCart[event.index] = newCart[event.index].copyWith(quantity: event.quantity);
        emit(currentState.copyWith(cart: newCart));
      }
    }
  }

  void _onProductRemoved(
    SupermarketFormProductRemoved event,
    Emitter<SupermarketFormState> emit,
  ) {
    if (state is SupermarketFormLoaded) {
      final currentState = state as SupermarketFormLoaded;
      if (event.index >= 0 && event.index < currentState.cart.length) {
        final newCart = List<CartItem>.from(currentState.cart);
        newCart.removeAt(event.index);
        emit(currentState.copyWith(cart: newCart));
      }
    }
  }

  Future<void> _onSubmitRequested(
    SupermarketFormSubmitRequested event,
    Emitter<SupermarketFormState> emit,
  ) async {
    if (state is SupermarketFormLoaded) {
      final currentState = state as SupermarketFormLoaded;
      if (currentState.selectedCategory == null) {
        emit(const SupermarketFormFailure('Selecciona una categoría'));
        emit(currentState);
        return;
      }
      if (currentState.cart.isEmpty) {
        emit(const SupermarketFormFailure('El carrito está vacío'));
        emit(currentState);
        return;
      }

      emit(SupermarketFormSubmitting());
      try {
        final productPayload = currentState.cart.map((item) => {
          'productId': item.product.id,
          'quantity': item.quantity,
        }).toList();

        await _createSupermarketExpense(
          categoryId: currentState.selectedCategory!.id,
          description: event.description,
          transactionDate: event.transactionDate,
          products: productPayload,
        );

        emit(SupermarketFormSuccess());
      } catch (e) {
        emit(SupermarketFormFailure(e.toString()));
        emit(currentState);
      }
    }
  }
}
