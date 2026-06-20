import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/incomes/data/incomes_repository_impl.dart';
import 'package:gastos_personales/layers/incomes/data/source/network/incomes_api.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/delete_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/get_incomes.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/bloc/incomes/incomes_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/filter_chips_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/gradient_summary_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/simple_page_app_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/transaction_card.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = IncomesRepositoryImpl(IncomesApiImpl());
    return BlocProvider(
      create: (_) => IncomesBloc(GetIncomes(repo), DeleteIncome(repo))
        ..add(const IncomesFetchRequested()),
      child: const _IncomeView(),
    );
  }
}

class _IncomeView extends StatelessWidget {
  const _IncomeView();

  Future<void> _openForm(BuildContext context, {Movement? income}) async {
    final result = await Navigator.pushNamed(
      context,
      newIncome,
      arguments: income,
    );
    if (result == true && context.mounted) {
      context.read<IncomesBloc>().add(const IncomesFetchRequested());
    }
  }

  Future<void> _confirmDelete(BuildContext context, Movement income) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar ingreso'),
        content: Text('¿Eliminar "${income.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<IncomesBloc>().add(IncomesDeleteRequested(income.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF34C759),
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: BlocBuilder<IncomesBloc, IncomesState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => context.read<IncomesBloc>().add(
                const IncomesFetchRequested(),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                children: [
                  const SimplePageAppBar(title: 'Ingresos'),
                  const SizedBox(height: 16),
                  if (state is IncomesLoaded)
                    GradientSummaryCard(
                      label: 'Ingresos del mes',
                      amountLabel:
                          '\$ ${state.monthlyTotal.toStringAsFixed(2)}',
                      gradientColors: const [
                        Color(0xFF3DDC73),
                        Color(0xFF1FAE6E),
                      ],
                    )
                  else
                    const GradientSummaryCard(
                      label: 'Ingresos del mes',
                      amountLabel: '\$ 0.00',
                      gradientColors: [
                        Color(0xFF3DDC73),
                        Color(0xFF1FAE6E),
                      ],
                    ),
                  const SizedBox(height: 18),
                  if (state is IncomesLoaded)
                    FilterChipsRow(
                      options: state.categories,
                      selected: state.selectedCategory,
                      onSelected: (value) => context.read<IncomesBloc>().add(
                        IncomesCategoryChanged(value),
                      ),
                    ),
                  const SizedBox(height: 16),
                  ..._buildBody(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, IncomesState state) {
    if (state is IncomesLoading || state is IncomesInitial) {
      return [
        const SizedBox(height: 80),
        const Center(child: CircularProgressIndicator()),
      ];
    }

    if (state is IncomesError) {
      return [
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<IncomesBloc>().add(
                  const IncomesFetchRequested(),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ];
    }

    final loaded = state as IncomesLoaded;
    if (loaded.filtered.isEmpty) {
      return [
        const SizedBox(height: 40),
        const Center(child: Text('Sin ingresos registrados')),
      ];
    }

    return [
      for (int i = 0; i < loaded.filtered.length; i++) ...[
        TransactionCard(
          entry: movementToEntry(loaded.filtered[i], isIncome: true),
          onTap: () => _openForm(context, income: loaded.filtered[i]),
          onLongPress: () => _confirmDelete(context, loaded.filtered[i]),
        ),
        if (i != loaded.filtered.length - 1) const SizedBox(height: 10),
      ],
    ];
  }
}
