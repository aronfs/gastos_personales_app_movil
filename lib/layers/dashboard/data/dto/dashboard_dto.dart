import 'package:gastos_personales/layers/dashboard/domain/entity/dashboard_summary.dart';

class CategoryItemDto extends CategoryItem {
  const CategoryItemDto({
    required super.categoryId,
    required super.categoryName,
    required super.categoryColor,
    required super.categoryIcon,
    required super.total,
    required super.count,
  });

  factory CategoryItemDto.fromMap(Map<String, dynamic> json) => CategoryItemDto(
    categoryId: json['categoryId'] as String,
    categoryName: json['categoryName'] as String,
    categoryColor: json['categoryColor'] as String,
    categoryIcon: json['categoryIcon'] as String,
    total: (json['total'] as num).toDouble(),
    count: json['count'] as int,
  );
}

class DashboardSummaryDto extends DashboardSummary {
  const DashboardSummaryDto({
    required super.totalIncome,
    required super.totalExpense,
    required super.currentBalance,
    required super.monthlyIncome,
    required super.monthlyExpense,
    required super.monthlyBalance,
    required super.categorySummary,
  });

  factory DashboardSummaryDto.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final catSummary = data['categorySummary'] as Map<String, dynamic>;

    final incomeList = (catSummary['income'] as List)
        .map((e) => CategoryItemDto.fromMap(e as Map<String, dynamic>))
        .toList();

    final expenseList = (catSummary['expense'] as List)
        .map((e) => CategoryItemDto.fromMap(e as Map<String, dynamic>))
        .toList();

    return DashboardSummaryDto(
      totalIncome: (data['totalIncome'] as num).toDouble(),
      totalExpense: (data['totalExpense'] as num).toDouble(),
      currentBalance: (data['currentBalance'] as num).toDouble(),
      monthlyIncome: (data['monthlyIncome'] as num).toDouble(),
      monthlyExpense: (data['monthlyExpense'] as num).toDouble(),
      monthlyBalance: (data['monthlyBalance'] as num).toDouble(),
      categorySummary: CategorySummary(
        income: incomeList,
        expense: expenseList,
      ),
    );
  }
}
