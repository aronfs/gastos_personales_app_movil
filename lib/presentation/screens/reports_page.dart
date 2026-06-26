import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/reports/data/reports_repository_impl.dart';
import 'package:gastos_personales/layers/reports/data/source/network/reports_api.dart';
import 'package:gastos_personales/layers/reports/domain/entity/report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_categories_report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_monthly_report.dart';
import 'package:gastos_personales/layers/reports/domain/usecase/get_yearly_report.dart';

import 'package:gastos_personales/presentation/screens/bloc/reports/reports_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_distribution_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_share.dart';
import 'package:gastos_personales/presentation/screens/widgets/income_expense_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/income_expense_point.dart';
import 'package:gastos_personales/presentation/screens/widgets/period_selector.dart';
import 'package:gastos_personales/presentation/screens/widgets/report_card.dart';

/// Punto de entrada: provee el [ReportsBloc].
class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ReportsRepositoryImpl(ReportsApiImpl());
    return BlocProvider(
      create: (_) => ReportsBloc(
        getMonthly: GetMonthlyReport(repo),
        getYearly: GetYearlyReport(repo),
        getCategories: GetCategoriesReport(repo),
      )..add(const ReportsFetchRequested(ReportPeriodType.month)),
      child: const _ReportsView(),
    );
  }
}

// ── Vista principal ───────────────────────────────────────────────────────────
class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView> {
  ReportPeriod _uiPeriod = ReportPeriod.mes;

  void _onPeriodChanged(ReportPeriod period) {
    setState(() => _uiPeriod = period);
    final blocPeriod = period == ReportPeriod.anio
        ? ReportPeriodType.year
        : ReportPeriodType.month;
    context.read<ReportsBloc>().add(ReportsPeriodChanged(blocPeriod));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ReportsBloc, ReportsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                final period = _uiPeriod == ReportPeriod.anio
                    ? ReportPeriodType.year
                    : ReportPeriodType.month;
                context.read<ReportsBloc>().add(ReportsFetchRequested(period));
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  // ── Selector de periodo ────────────────────────────
                  PeriodSelector(
                    selected: _uiPeriod,
                    onChanged: _onPeriodChanged,
                  ),
                  const SizedBox(height: 16),

                  // ── Cuerpo dinámico ────────────────────────────────
                  _buildBody(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReportsState state) {
    // Loading
    if (state is ReportsLoading || state is ReportsInitial) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Error
    if (state is ReportsError) {
      return _ErrorView(
        message: state.message,
        onRetry: () {
          final period = _uiPeriod == ReportPeriod.anio
              ? ReportPeriodType.year
              : ReportPeriodType.month;
          context.read<ReportsBloc>().add(ReportsFetchRequested(period));
        },
      );
    }

    // Mes cargado
    if (state is ReportsMonthLoaded) {
      return _MonthContent(
        monthly: state.monthly,
        categories: state.categories,
      );
    }

    // Año cargado
    if (state is ReportsYearLoaded) {
      return _YearContent(yearly: state.yearly, categories: state.categories);
    }

    return const SizedBox.shrink();
  }
}

// ── Vista mes ─────────────────────────────────────────────────────────────────
class _MonthContent extends StatelessWidget {
  final MonthlyReport monthly;
  final CategoriesReport categories;

  const _MonthContent({required this.monthly, required this.categories});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final s = monthly.summary;

    // Construir IncomeExpensePoints con las categorías del mes
    final chartData = [
      IncomeExpensePoint(
        label: monthly.period.monthName.substring(0, 3),
        income: s.totalIncome,
        expense: s.totalExpense,
      ),
    ];

    // Construir CategoryShare para el donut
    final catShares = _buildCategoryShares(categories);

    return Column(
      children: [
        // ── Resumen del mes ──────────────────────────────────────
        _SummaryRow(
          income: s.totalIncome,
          expense: s.totalExpense,
          balance: s.balance,
        ),
        const SizedBox(height: 16),

        // ── Transacciones del mes ────────────────────────────────
        ReportCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, color: cs.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${s.transactionCount} transacciones en ${monthly.period.monthName}',
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Gráfico ingresos vs gastos ───────────────────────────
        IncomeExpenseCard(
          periodLabel: '${monthly.period.monthName} ${monthly.period.year}',
          data: chartData,
        ),
        const SizedBox(height: 16),

        // ── Distribución por categoría ───────────────────────────
        if (catShares.isNotEmpty) ...[
          _CategorySectionHeader(
            onManage: () => Navigator.pushNamed(context, '/categoriesPage'),
          ),
          const SizedBox(height: 8),
          CategoryDistributionCard(
            totalLabel: '\$ ${s.totalExpense.toStringAsFixed(0)}',
            categories: catShares,
          ),
        ],
      ],
    );
  }

  List<CategoryShare> _buildCategoryShares(CategoriesReport cats) {
    final items = cats.expenseCategories.isNotEmpty
        ? cats.expenseCategories
        : cats.incomeCategories;

    return items.map((c) {
      final color = _hexToColor(c.color);
      return CategoryShare(
        name: c.categoryName,
        percentage: c.percentage,
        color: color,
      );
    }).toList();
  }
}

// ── Vista año ─────────────────────────────────────────────────────────────────
class _YearContent extends StatelessWidget {
  final YearlyReport yearly;
  final CategoriesReport categories;

  const _YearContent({required this.yearly, required this.categories});

  @override
  Widget build(BuildContext context) {
    final s = yearly.summary;

    // Construir puntos para el gráfico — uno por mes con datos
    final chartData = yearly.months
        .where((m) => m.income > 0 || m.expense > 0)
        .map(
          (m) => IncomeExpensePoint(
            label: m.monthName.substring(0, 3),
            income: m.income,
            expense: m.expense,
          ),
        )
        .toList();

    final catShares = _buildCategoryShares(categories);

    return Column(
      children: [
        // ── Resumen anual ────────────────────────────────────────
        _SummaryRow(
          income: s.totalIncome,
          expense: s.totalExpense,
          balance: s.balance,
        ),
        const SizedBox(height: 16),

        // ── Gráfico mensual ──────────────────────────────────────
        if (chartData.isNotEmpty)
          IncomeExpenseCard(periodLabel: '${yearly.year}', data: chartData),
        const SizedBox(height: 16),

        // ── Distribución por categoría ───────────────────────────
        if (catShares.isNotEmpty) ...[
          _CategorySectionHeader(
            onManage: () => Navigator.pushNamed(context, '/categoriesPage'),
          ),
          const SizedBox(height: 8),
          CategoryDistributionCard(
            totalLabel: '\$ ${s.totalExpense.toStringAsFixed(0)}',
            categories: catShares,
          ),
        ],
      ],
    );
  }

  List<CategoryShare> _buildCategoryShares(CategoriesReport cats) {
    final items = cats.expenseCategories.isNotEmpty
        ? cats.expenseCategories
        : cats.incomeCategories;
    return items
        .map(
          (c) => CategoryShare(
            name: c.categoryName,
            percentage: c.percentage,
            color: _hexToColor(c.color),
          ),
        )
        .toList();
  }
}

// ── Widget resumen (ingresos / gastos / balance) ──────────────────────────────
class _SummaryRow extends StatelessWidget {
  final double income;
  final double expense;
  final double balance;

  const _SummaryRow({
    required this.income,
    required this.expense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _SummaryTile(
            label: 'Ingresos',
            amount: income,
            color: cs.tertiary,
            icon: Icons.arrow_downward_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryTile(
            label: 'Gastos',
            amount: expense,
            color: cs.error,
            icon: Icons.arrow_upward_rounded,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryTile(
            label: 'Balance',
            amount: balance,
            color: cs.primary,
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
      ],
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryTile({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ReportCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '\$ ${amount.toStringAsFixed(0)}',
            style: tt.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: cs.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: tt.bodyMedium),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Encabezado de sección de categorías ───────────────────────────────────────
class _CategorySectionHeader extends StatelessWidget {
  final VoidCallback onManage;

  const _CategorySectionHeader({required this.onManage});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(Icons.category_outlined, size: 18, color: cs.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          'Categories',
          style: tt.titleSmall?.copyWith(color: cs.onSurfaceVariant),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onManage,
          icon: const Icon(Icons.tune, size: 16),
          label: const Text('Manage'),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            foregroundColor: cs.primary,
          ),
        ),
      ],
    );
  }
}

// ── Helper: convierte hex "#3B82F6" → Color ───────────────────────────────────
Color _hexToColor(String hex) {
  final h = hex.replaceAll('#', '');
  return Color(int.parse('FF$h', radix: 16));
}
