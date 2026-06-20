import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

class MovementCategoryDto extends MovementCategory {
  const MovementCategoryDto({
    required super.id,
    required super.name,
    required super.icon,
    required super.color,
  });

  factory MovementCategoryDto.fromMap(Map<String, dynamic> json) =>
      MovementCategoryDto(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        color: json['color'] as String,
      );
}

class ProductDto extends Product {
  const ProductDto({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.unitPrice,
  });

  factory ProductDto.fromMap(Map<String, dynamic> json) => ProductDto(
        id: json['id'] as String,
        categoryId: json['categoryId'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        unitPrice: double.tryParse(json['unitPrice'].toString()) ?? 0.0,
      );
}

class ExpenseProductDto extends ExpenseProduct {
  const ExpenseProductDto({
    required super.id,
    required super.expenseId,
    required super.productId,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
    super.product,
  });

  factory ExpenseProductDto.fromMap(Map<String, dynamic> json) =>
      ExpenseProductDto(
        id: json['id'] as String,
        expenseId: json['expenseId'] as String,
        productId: json['productId'] as String,
        quantity: json['quantity'] as int,
        unitPrice: double.tryParse(json['unitPrice'].toString()) ?? 0.0,
        subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
        product: json['product'] != null
            ? ProductDto.fromMap(json['product'] as Map<String, dynamic>)
            : null,
      );
}

class MovementDto extends Movement {
  const MovementDto({
    required super.id,
    required super.type,
    required super.amount,
    required super.description,
    required super.category,
    required super.transactionDate,
    required super.createdAt,
    super.expenseProducts = const [],
  });

  factory MovementDto.fromMap(Map<String, dynamic> json) {
    List<ExpenseProduct> products = [];
    if (json['expenseProducts'] != null) {
      products = (json['expenseProducts'] as List)
          .map((e) => ExpenseProductDto.fromMap(e as Map<String, dynamic>))
          .toList();
    }

    return MovementDto(
      id: json['id'] as String,
      type: (json['type']?.toString() ??
                  json['category']?['type']?.toString() ??
                  '')
              .toUpperCase() ==
              'INCOME'
          ? MovementType.income
          : MovementType.expense,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      description: json['description'] as String,
      category: json['category'] != null
          ? MovementCategoryDto.fromMap(
              json['category'] as Map<String, dynamic>)
          : MovementCategoryDto(
              id: json['categoryId']?.toString() ?? '',
              name: 'Categoría',
              icon: 'help',
              color: '#808080',
            ),
      transactionDate: json['transactionDate']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      expenseProducts: products,
    );
  }

  /// Parsea la respuesta completa: `{ "data": [ ... ] }`
  static List<Movement> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return data
        .map((e) => MovementDto.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
