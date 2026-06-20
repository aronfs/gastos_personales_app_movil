import 'package:gastos_personales/layers/reports/domain/entity/report.dart';

// ── Monthly ───────────────────────────────────────────────────────────────────

class MonthlyReportDto extends MonthlyReport {
  const MonthlyReportDto({required super.period, required super.summary});

  factory MonthlyReportDto.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final p = data['period'] as Map<String, dynamic>;
    final s = data['summary'] as Map<String, dynamic>;

    return MonthlyReportDto(
      period: ReportDatePeriod(
        year: p['year'] as int,
        month: p['month'] as int,
        monthName: p['monthName'] as String,
      ),
      summary: ReportSummary(
        totalIncome: (s['totalIncome'] as num).toDouble(),
        totalExpense: (s['totalExpense'] as num).toDouble(),
        balance: (s['balance'] as num).toDouble(),
        transactionCount: s['transactionCount'] as int,
      ),
    );
  }
}

// ── Yearly ────────────────────────────────────────────────────────────────────

class YearlyReportDto extends YearlyReport {
  const YearlyReportDto({
    required super.year,
    required super.summary,
    required super.months,
  });

  factory YearlyReportDto.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final s = data['summary'] as Map<String, dynamic>;
    final rawMonths = data['months'] as List;

    return YearlyReportDto(
      year: data['year'] as int,
      summary: YearlySummary(
        totalIncome: (s['totalIncome'] as num).toDouble(),
        totalExpense: (s['totalExpense'] as num).toDouble(),
        balance: (s['balance'] as num).toDouble(),
      ),
      months: rawMonths.map((m) {
        final month = m as Map<String, dynamic>;
        return MonthData(
          month: month['month'] as int,
          monthName: month['monthName'] as String,
          income: (month['income'] as num).toDouble(),
          expense: (month['expense'] as num).toDouble(),
          balance: (month['balance'] as num).toDouble(),
          incomeCount: month['incomeCount'] as int,
          expenseCount: month['expenseCount'] as int,
        );
      }).toList(),
    );
  }
}

// ── Categories ────────────────────────────────────────────────────────────────

class CategoriesReportDto extends CategoriesReport {
  const CategoriesReportDto({
    required super.summary,
    required super.incomeCategories,
    required super.expenseCategories,
  });

  factory CategoriesReportDto.fromMap(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final s = data['summary'] as Map<String, dynamic>;

    return CategoriesReportDto(
      summary: CategoriesReportSummary(
        totalIncome: (s['totalIncome'] as num).toDouble(),
        totalExpense: (s['totalExpense'] as num).toDouble(),
        balance: (s['balance'] as num).toDouble(),
      ),
      incomeCategories: _parseItems(data['incomeCategories'] as List),
      expenseCategories: _parseItems(data['expenseCategories'] as List),
    );
  }

  static List<CategoryReportItem> _parseItems(List raw) => raw.map((e) {
    final m = e as Map<String, dynamic>;
    return CategoryReportItem(
      categoryId: m['categoryId'] as String,
      categoryName: m['categoryName'] as String,
      color: m['color'] as String,
      icon: m['icon'] as String,
      total: (m['total'] as num).toDouble(),
      count: m['count'] as int,
      percentage: (m['percentage'] as num).toDouble(),
    );
  }).toList();
}
