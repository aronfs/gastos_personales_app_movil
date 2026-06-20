import 'package:equatable/equatable.dart';

class IncomeCategory extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;
  final String type;

  const IncomeCategory({
    required this.id,
    required this.userId,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  @override
  List<Object?> get props => [id];
}

class Income extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final IncomeCategory category;

  const Income({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  @override
  List<Object?> get props => [id];
}
