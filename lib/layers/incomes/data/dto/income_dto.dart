import 'package:gastos_personales/layers/incomes/domain/entity/income.dart';

class IncomeCategoryDto extends IncomeCategory {
  const IncomeCategoryDto({
    required super.id,
    required super.userId,
    required super.name,
    required super.icon,
    required super.color,
    required super.type,
  });

  factory IncomeCategoryDto.fromMap(Map<String, dynamic> json) =>
      IncomeCategoryDto(
        id: json['id'] as String,
        userId: json['userId'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        color: json['color'] as String,
        type: json['type'] as String,
      );
}

class IncomeDto extends Income {
  const IncomeDto({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.amount,
    required super.description,
    required super.transactionDate,
    required super.createdAt,
    required super.updatedAt,
    required super.category,
  });

  factory IncomeDto.fromMap(Map<String, dynamic> json) => IncomeDto(
    id: json['id'] as String,
    userId: json['userId'] as String,
    categoryId: json['categoryId'] as String,
    amount: double.parse(json['amount'].toString()),
    description: json['description'] as String,
    transactionDate: DateTime.parse(json['transactionDate'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    category: IncomeCategoryDto.fromMap(
      json['category'] as Map<String, dynamic>,
    ),
  );

  Map<String, dynamic> toCreateMap() => {
    'categoryId': categoryId,
    'amount': amount,
    'description': description,
    'transactionDate': transactionDate.toIso8601String().split('T').first,
  };

  Map<String, dynamic> toUpdateMap() => {
    if (categoryId.isNotEmpty) 'categoryId': categoryId,
    if (amount > 0) 'amount': amount,
    if (description.isNotEmpty) 'description': description,
    'transactionDate': transactionDate.toIso8601String().split('T').first,
  };

  static List<Income> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return data
        .map((e) => IncomeDto.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
