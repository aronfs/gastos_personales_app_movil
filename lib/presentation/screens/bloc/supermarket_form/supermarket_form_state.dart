part of 'supermarket_form_bloc.dart';

class CartItem extends Equatable {
  final Product product;
  final int quantity;

  const CartItem(this.product, this.quantity);

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product ?? this.product,
      quantity ?? this.quantity,
    );
  }

  double get subtotal => product.unitPrice * quantity;

  @override
  List<Object?> get props => [product, quantity];
}

abstract class SupermarketFormState extends Equatable {
  const SupermarketFormState();

  @override
  List<Object?> get props => [];
}

class SupermarketFormInitial extends SupermarketFormState {}

class SupermarketFormLoading extends SupermarketFormState {}

class SupermarketFormLoaded extends SupermarketFormState {
  final List<Category> categories;
  final Category? selectedCategory;
  final List<Product> availableProducts;
  final List<CartItem> cart;
  final double baseCupo;

  const SupermarketFormLoaded({
    required this.categories,
    this.selectedCategory,
    required this.availableProducts,
    required this.cart,
    required this.baseCupo,
  });

  SupermarketFormLoaded copyWith({
    List<Category>? categories,
    Category? selectedCategory,
    List<Product>? availableProducts,
    List<CartItem>? cart,
    double? baseCupo,
  }) {
    return SupermarketFormLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      availableProducts: availableProducts ?? this.availableProducts,
      cart: cart ?? this.cart,
      baseCupo: baseCupo ?? this.baseCupo,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategory, availableProducts, cart, baseCupo];
}

class SupermarketFormSubmitting extends SupermarketFormState {}

class SupermarketFormSuccess extends SupermarketFormState {}

class SupermarketFormFailure extends SupermarketFormState {
  final String message;

  const SupermarketFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
