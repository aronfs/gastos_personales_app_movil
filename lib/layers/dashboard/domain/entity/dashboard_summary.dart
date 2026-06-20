import 'package:equatable/equatable.dart';

class CategoryItem extends Equatable {
  final String categoryId;
  final String categoryName;
  final String categoryColor;
  final String categoryIcon;
  final double total;
  final int count;

  const CategoryItem({
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryIcon,
    required this.total,
    required this.count,
  });

  @override
  List<Object?> get props => [categoryId];
}

class CategorySummary extends Equatable {
  final List<CategoryItem> income;
  final List<CategoryItem> expense;

  const CategorySummary({required this.income, required this.expense});

  @override
  List<Object?> get props => [income, expense];
}

class DashboardSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double currentBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double monthlyBalance;
  final CategorySummary categorySummary;

  const DashboardSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.currentBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.monthlyBalance,
    required this.categorySummary,
  });

  @override
  List<Object?> get props => [
    totalIncome,
    totalExpense,
    currentBalance,
    monthlyIncome,
    monthlyExpense,
    monthlyBalance,
  ];
}
