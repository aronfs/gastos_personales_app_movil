import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/movements/data/movements_repository_impl.dart';
import 'package:gastos_personales/layers/movements/data/source/network/movements_api.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/movements/domain/usecase/get_movements.dart';
import 'package:gastos_personales/presentation/screens/bloc/movements/movements_bloc.dart';

/// Punto de entrada: provee el [MovementsBloc].
class MovementsPage extends StatelessWidget {
  const MovementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovementsBloc(
        GetMovements(MovementsRepositoryImpl(MovementsApiImpl())),
      )..add(const MovementsFetchRequested()),
      child: const _MovementsView(),
    );
  }
}

// ── Vista principal ───────────────────────────────────────────────────────────
class _MovementsView extends StatefulWidget {
  const _MovementsView();

  @override
  State<_MovementsView> createState() => _MovementsViewState();
}

class _MovementsViewState extends State<_MovementsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<MovementsBloc, MovementsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Buscador ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: cs.shadow.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => context.read<MovementsBloc>().add(
                              MovementsSearchChanged(v),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Buscar movimiento...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: cs.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.tune_outlined, color: cs.onSurface),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Chips de categoría (solo en estado Loaded) ──────────
                if (state is MovementsLoaded) ...[
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final cat = state.categories[i];
                        final selected = cat == state.selectedCategory;
                        return GestureDetector(
                          onTap: () => context.read<MovementsBloc>().add(
                            MovementsCategoryChanged(cat),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: selected
                                  ? cs.primary
                                  : cs.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.shadow.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                cat,
                                style: tt.labelMedium?.copyWith(
                                  color: selected ? cs.onPrimary : cs.onSurface,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // ── Cuerpo: loading / error / lista ─────────────────────
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MovementsState state) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    // Loading
    if (state is MovementsLoading || state is MovementsInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (state is MovementsError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: cs.error),
              const SizedBox(height: 12),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: tt.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => context.read<MovementsBloc>().add(
                  const MovementsFetchRequested(),
                ),
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // Loaded
    final loaded = state as MovementsLoaded;

    if (loaded.filtered.isEmpty) {
      return Center(
        child: Text(
          'Sin movimientos',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }

    return Column(
      children: [
        // Header totales
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${loaded.filtered.length} movimiento${loaded.filtered.length != 1 ? 's' : ''}',
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '\$ ${loaded.totalFiltered.abs().toStringAsFixed(2)}',
                style: tt.titleMedium?.copyWith(
                  color: loaded.totalFiltered < 0 ? cs.error : cs.tertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Lista
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => context.read<MovementsBloc>().add(
              const MovementsFetchRequested(),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: loaded.filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) =>
                  _MovementCard(movement: loaded.filtered[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Card ──────────────────────────────────────────────────────────────────────
class _MovementCard extends StatelessWidget {
  final Movement movement;

  const _MovementCard({required this.movement});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final amountColor = movement.isExpense ? cs.error : cs.tertiary;
    final iconBgColor = movement.isExpense
        ? cs.errorContainer
        : cs.tertiaryContainer;
    final iconColor = movement.isExpense ? cs.error : cs.tertiary;
    final sign = movement.isExpense ? '-' : '+';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ícono de categoría
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              movement.isExpense
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Descripción y categoría
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movement.description, style: tt.titleMedium),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      movement.category.name,
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· ${movement.transactionDate}',
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Monto con signo y color
          Text(
            '$sign\$ ${movement.amount.toStringAsFixed(2)}',
            style: tt.titleMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
