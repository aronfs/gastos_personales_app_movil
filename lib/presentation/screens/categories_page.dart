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

  Future<void> _showCategoryDialog(
    BuildContext context, {
    Category? category,
  }) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(
      text: category?.icon ?? 'restaurant',
    );
    final colorController = TextEditingController(
      text: category?.color ?? '#2962FF',
    );
    var selectedType = category?.type ?? CategoryType.expense;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(category == null ? 'Nueva categoría' : 'Editar categoría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: iconController,
                  decoration: const InputDecoration(labelText: 'Icono'),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color (#HEX)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<CategoryType>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: const [
                    DropdownMenuItem(
                      value: CategoryType.expense,
                      child: Text('Gasto'),
                    ),
                    DropdownMenuItem(
                      value: CategoryType.income,
                      child: Text('Ingreso'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => selectedType = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (saved != true || !context.mounted) return;

    final bloc = context.read<CategoriesBloc>();
    if (category == null) {
      bloc.add(
        CategoriesCreateRequested(
          name: nameController.text.trim(),
          icon: iconController.text.trim(),
          color: colorController.text.trim(),
          type: selectedType,
        ),
      );
    } else {
      bloc.add(
        CategoriesUpdateRequested(
          id: category.id,
          name: nameController.text.trim(),
          icon: iconController.text.trim(),
          color: colorController.text.trim(),
        ),
      );
    }
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
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: BlocConsumer<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state is CategoriesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
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

    final loaded = state as CategoriesLoaded;
    final displays = loaded.categories.map(categoryToDisplay).toList();

    return [
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
              onTap: () => _showCategoryDialog(context),
            );
          }
          final display = displays[index];
          final category = loaded.categories[index];
          return CategoryGridCard(
            category: display,
            onTap: () => _showCategoryDialog(context, category: category),
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
