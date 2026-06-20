import 'package:equatable/equatable.dart';

// Monthly report

class ReportDatePeriod extends Equatable {
  final int year;
  final int month;
  final String monthName;

  const ReportDatePeriod({
    required this.year,
    required this.month,
    required this.monthName,
  });

  @override
  List<Object?> get props => [year, month];
}

class ReportSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final int transactionCount;

  const ReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.transactionCount,
  });

  @override
  List<Object?> get props => [totalIncome, totalExpense, balance];
}

class MonthlyReport extends Equatable {
  final ReportDatePeriod period;
  final ReportSummary summary;

  const MonthlyReport({required this.period, required this.summary});

  @override
  List<Object?> get props => [period, summary];
}

// Yearly report

class MonthData extends Equatable {
  final int month;
  final String monthName;
  final double income;
  final double expense;
  final double balance;
  final int incomeCount;
  final int expenseCount;

  const MonthData({
    required this.month,
    required this.monthName,
    required this.income,
    required this.expense,
    required this.balance,
    required this.incomeCount,
    required this.expenseCount,
  });

  @override
  List<Object?> get props => [month];
}

class YearlySummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const YearlySummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  @override
  List<Object?> get props => [totalIncome, totalExpense, balance];
}

class YearlyReport extends Equatable {
  final int year;
  final YearlySummary summary;
  final List<MonthData> months;

  const YearlyReport({
    required this.year,
    required this.summary,
    required this.months,
  });

  @override
  List<Object?> get props => [year, summary];
}

// Categories report

class CategoryReportItem extends Equatable {
  final String categoryId;
  final String categoryName;
  final String color;
  final String icon;
  final double total;
  final int count;
  final double percentage;

  const CategoryReportItem({
    required this.categoryId,
    required this.categoryName,
    required this.color,
    required this.icon,
    required this.total,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [categoryId];
}

class CategoriesReportSummary extends Equatable {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  const CategoriesReportSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  @override
  List<Object?> get props => [totalIncome, totalExpense, balance];
}

class CategoriesReport extends Equatable {
  final CategoriesReportSummary summary;
  final List<CategoryReportItem> incomeCategories;
  final List<CategoryReportItem> expenseCategories;

  const CategoriesReport({
    required this.summary,
    required this.incomeCategories,
    required this.expenseCategories,
  });

  @override
  List<Object?> get props => [summary];
}
