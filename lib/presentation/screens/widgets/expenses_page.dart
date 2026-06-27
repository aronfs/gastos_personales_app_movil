import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/expenses/data/expenses_repository_impl.dart';
import 'package:gastos_personales/layers/expenses/data/source/network/expenses_api.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/delete_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/get_expenses.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/bloc/expenses/expenses_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/date_group_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/filter_chips_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/search_filter_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/simple_page_app_bar.dart';
import 'package:gastos_personales/presentation/screens/widgets/transaction_card.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ExpensesRepositoryImpl(ExpensesApiImpl());
    return BlocProvider(
      create: (_) => ExpensesBloc(GetExpenses(repo), DeleteExpense(repo))
        ..add(const ExpensesFetchRequested()),
      child: const _ExpensesView(),
    );
  }
}

class _ExpensesView extends StatefulWidget {
  const _ExpensesView();

  @override
  State<_ExpensesView> createState() => _ExpensesViewState();
}

class _ExpensesViewState extends State<_ExpensesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openForm(BuildContext context, {Movement? expense}) async {
    final result = await Navigator.pushNamed(
      context,
      newExpense,
      arguments: expense,
    );
    if (result == true && context.mounted) {
      context.read<ExpensesBloc>().add(const ExpensesFetchRequested());
    }
  }

  Future<void> _confirmDelete(BuildContext context, Movement expense) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar gasto'),
        content: Text('¿Eliminar "${expense.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<ExpensesBloc>().add(ExpensesDeleteRequested(expense.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<ExpensesBloc, ExpensesState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => context.read<ExpensesBloc>().add(
                const ExpensesFetchRequested(),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                children: [
                  const SimplePageAppBar(title: 'Gastos'),
                  const SizedBox(height: 16),
                  SearchFilterBar(
                    hintText: 'Buscar gasto...',
                    controller: _searchController,
                    onChanged: (value) => context.read<ExpensesBloc>().add(
                      ExpensesSearchChanged(value),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (state is ExpensesLoaded)
                    FilterChipsRow(
                      options: state.categories,
                      selected: state.selectedCategory,
                      onSelected: (value) => context.read<ExpensesBloc>().add(
                        ExpensesCategoryChanged(value),
                      ),
                    ),
                  const SizedBox(height: 8),
                  ..._buildBody(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, ExpensesState state) {
    if (state is ExpensesLoading || state is ExpensesInitial) {
      return [
        const SizedBox(height: 80),
        const Center(child: CircularProgressIndicator()),
      ];
    }

    if (state is ExpensesError) {
      return [
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<ExpensesBloc>().add(
                  const ExpensesFetchRequested(),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ];
    }

    final loaded = state as ExpensesLoaded;
    if (loaded.filtered.isEmpty) {
      return [
        const SizedBox(height: 40),
        const Center(child: Text('Sin gastos registrados')),
      ];
    }

    final grouped = groupByDate(loaded.filtered);
    final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    final widgets = <Widget>[];
    for (final date in dates) {
      final items = grouped[date]!;
      final total = items.fold(0.0, (sum, m) => sum + m.amount);

      widgets.add(DateGroupHeader(
        dateLabel: dateGroupLabel(date),
        totalLabel: '-\$ ${total.toStringAsFixed(2)}',
      ));
      widgets.add(const SizedBox(height: 10));

      for (int i = 0; i < items.length; i++) {
        widgets.add(
          TransactionCard(
            entry: movementToEntry(items[i]),
            onTap: () => _openForm(context, expense: items[i]),
            onLongPress: () => _confirmDelete(context, items[i]),
          ),
        );
        if (i != items.length - 1) widgets.add(const SizedBox(height: 10));
      }
      widgets.add(const SizedBox(height: 18));
    }

    return widgets;
  }
}
