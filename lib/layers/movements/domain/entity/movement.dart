import 'package:equatable/equatable.dart';

enum MovementType { income, expense }

class MovementCategory extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String color;

  const MovementCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [id];
}

class Product extends Equatable {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final double unitPrice;

  const Product({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.unitPrice,
  });

  @override
  List<Object?> get props => [id];
}

class ExpenseProduct extends Equatable {
  final String id;
  final String expenseId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final Product? product;

  const ExpenseProduct({
    required this.id,
    required this.expenseId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
    this.product,
  });

  @override
  List<Object?> get props => [id];
}

class Movement extends Equatable {
  final String id;
  final MovementType type;
  final double amount;
  final String description;
  final MovementCategory category;
  final String transactionDate;
  final String createdAt;
  final List<ExpenseProduct> expenseProducts;

  const Movement({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.category,
    required this.transactionDate,
    required this.createdAt,
    this.expenseProducts = const [],
  });

  bool get isExpense => type == MovementType.expense;

  @override
  List<Object?> get props => [id];
}
