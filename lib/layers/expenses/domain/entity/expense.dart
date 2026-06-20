import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String icon;
  final String color;
  final String type;

  const ExpenseCategory({
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

class Expense extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final double amount;
  final String description;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ExpenseCategory category;

  const Expense({
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
