import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/create_category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/delete_category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/update_category.dart';
import 'package:gastos_personales/presentation/screens/bloc/categories/categories_bloc.dart';
import 'package:gastos_personales/presentation/screens/category_create_page.dart';
import 'package:gastos_personales/presentation/screens/category_edit_page.dart';
import 'package:gastos_personales/presentation/screens/widgets/add_category_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_grid_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/most_used_categories_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/simple_page_app_bar.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = CategoriesRepositoryImpl(CategoriesApiImpl());

    return BlocProvider(
      create: (_) => CategoriesBloc(
        GetCategories(repo),
        CreateCategory(repo),
        UpdateCategory(repo),
        DeleteCategory(repo),
      )..add(const CategoriesFetchRequested()),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatelessWidget {
  const _CategoriesView();

  void _navigateToCreate(BuildContext context) {
    final bloc = context.read<CategoriesBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: const CategoryCreatePage(),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Eliminar "${category.name}"?'),
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
      context.read<CategoriesBloc>().add(
        CategoriesDeleteRequested(category.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state is CategoriesUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Categoría actualizada correctamente.'),
                  backgroundColor: Color(0xFF43A047),
                ),
              );
              context.read<CategoriesBloc>().add(
                const CategoriesFetchRequested(),
              );
            } else if (state is CategoriesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
              if (state.message.contains('Sesión expirada')) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signin',
                  (route) => false,
                );
              }
              context.read<CategoriesBloc>().add(
                const CategoriesFetchRequested(),
              );
            }
          },
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async => context.read<CategoriesBloc>().add(
                const CategoriesFetchRequested(),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  const SimplePageAppBar(title: 'Categorías'),
                  const SizedBox(height: 20),
                  ..._buildBody(context, state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, CategoriesState state) {
    if (state is CategoriesLoading || state is CategoriesInitial) {
      return [
        const SizedBox(height: 80),
        const Center(child: CircularProgressIndicator()),
      ];
    }

    if (state is CategoriesError) {
      return [
        const SizedBox(height: 40),
        Center(
          child: Column(
            children: [
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<CategoriesBloc>().add(
                  const CategoriesFetchRequested(),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ];
    }

    final categories = state is CategoriesLoaded
        ? state.categories
        : state is CategoriesUpdating
            ? state.categories
            : state is CategoriesUpdateSuccess
                ? state.categories
                : <Category>[];

    if (categories.isEmpty) {
      return [
        const SizedBox(height: 80),
        const Center(child: Text('No hay categorías')),
      ];
    }

    final isUpdating = state is CategoriesUpdating;
    final displays = categories.map(categoryToDisplay).toList();

    return [
      if (isUpdating)
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: LinearProgressIndicator(),
        ),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displays.length + 1,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          if (index == displays.length) {
            return AddCategoryCard(
              onTap: () => _navigateToCreate(context),
            );
          }
          final display = displays[index];
          final category = categories[index];
          return CategoryGridCard(
            category: display,
            onTap: () {
              final bloc = context.read<CategoriesBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: CategoryEditPage(category: category),
                  ),
                ),
              );
            },
            onLongPress: () => _confirmDelete(context, category),
          );
        },
      ),
      if (displays.length >= 3) ...[
        const SizedBox(height: 24),
        MostUsedCategoriesCard(
          categories: displays.take(3).toList(),
          amountLabels: List.filled(3, '—'),
        ),
      ],
    ];
  }

}
