import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/create_category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/setup_initial_categories.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/session/bloc/initial_setup/initial_setup_bloc.dart';

class InitialSetupPage extends StatelessWidget {
  const InitialSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CategoriesRepositoryImpl(CategoriesApiImpl());

    return BlocProvider(
      create: (_) => InitialSetupBloc(
        SetupInitialCategories(CreateCategory(repo)),
      ),
      child: const _InitialSetupView(),
    );
  }
}

class _InitialSetupView extends StatelessWidget {
  const _InitialSetupView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<InitialSetupBloc, InitialSetupState>(
          listener: (context, state) {
            if (state is InitialSetupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Categorías iniciales creadas correctamente.',
                  ),
                  backgroundColor: Color(0xFF43A047),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                home,
                (route) => false,
              );
            } else if (state is InitialSetupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: cs.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is InitialSetupLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.category_outlined,
                      size: 40,
                      color: cs.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '¡Bienvenido!',
                    style: textTheme.headlineLarge?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Parece que todavía no tienes categorías. '
                    'Vamos a crear unas básicas para que puedas comenzar '
                    'a registrar tus ingresos y gastos.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Se crearán las siguientes categorías:',
                    style: textTheme.titleMedium?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _CategoryChip(
                    label: 'Salario',
                    icon: Icons.attach_money,
                    color: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(height: 8),
                  _CategoryChip(
                    label: 'Alimentación',
                    icon: Icons.restaurant,
                    color: const Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 8),
                  _CategoryChip(
                    label: 'Transporte',
                    icon: Icons.directions_car,
                    color: const Color(0xFFF97316),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => context.read<InitialSetupBloc>().add(
                              const InitialSetupRequested(),
                            ),
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.onPrimary,
                            ),
                          )
                        : const Text('Crear categorías iniciales'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: textTheme.titleMedium?.copyWith(
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
