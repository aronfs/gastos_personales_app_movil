import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/dashboard/data/dashboard_repository_impl.dart';
import 'package:gastos_personales/layers/dashboard/data/source/network/dashboard_api.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/presentation/screens/bloc/dashboard/dashboard_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/balance_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_summary_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/profile_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/saving_row.dart';

/// Punto de entrada: provee el [DashboardBloc].
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(
        GetDashboard(DashboardRepositoryImpl(DashboardApiImpl())),
      )..add(const DashboardFetchRequested()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            // ── Loading ────────────────────────────────────────────────
            if (state is DashboardLoading || state is DashboardInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            // ── Error ──────────────────────────────────────────────────
            if (state is DashboardError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => context.read<DashboardBloc>().add(
                          const DashboardFetchRequested(),
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ── Loaded ─────────────────────────────────────────────────
            final summary = (state as DashboardLoaded).summary;

            return RefreshIndicator(
              onRefresh: () async => context.read<DashboardBloc>().add(
                const DashboardFetchRequested(),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ── Header: saludo ───────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 35,
                      right: 35,
                      top: 20,
                    ),
                    child: ProfileBar(gretting: loc.greeting, name: 'aaron'),
                  ),

                  // ── Balance card ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: BalanceCard(
                      head: loc.balance,
                      title: loc.incost,
                      subtitle: loc.enough,
                      valueBalance: summary.currentBalance,
                      valueIn: summary.monthlyIncome,
                      valueEnough: summary.monthlyExpense,
                    ),
                  ),

                  // ── Ahorros del mes ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SavingsRow(
                      title: loc.saving,
                      subtitle: loc.goal,
                      valueSaving: summary.monthlyBalance,
                      valueGoal: summary.totalIncome > 0
                          ? (summary.monthlyBalance / summary.totalIncome) * 100
                          : 0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Categorías de ingresos ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategorySummaryCard(
                      title: loc.incost,
                      items: summary.categorySummary.income,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Categorías de gastos ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CategorySummaryCard(
                      title: loc.enough,
                      items: summary.categorySummary.expense,
                      isExpense: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
