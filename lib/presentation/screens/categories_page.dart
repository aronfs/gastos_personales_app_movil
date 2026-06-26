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
import 'package:gastos_personales/presentation/screens/category_edit_page.dart';
import 'package:gastos_personales/presentation/screens/widgets/add_category_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_grid_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/most_used_categories_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/simple_page_app_bar.dart';
import 'package:gastos_personales/util/color_helper.dart';
import 'package:gastos_personales/util/icon_helper.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';

const _iconNames = [
  'salary', 'freelance', 'investment', 'gift', 'bonus',
  'restaurant', 'coffee', 'grocery', 'fastfood', 'pizza',
  'alcohol', 'dessert', 'delivery',
  'car', 'transport', 'fuel', 'parking', 'taxi', 'travel', 'train',
  'shopping', 'clothes', 'electronics', 'books', 'online',
  'home', 'rent', 'electricity', 'water', 'internet', 'utilities',
  'health', 'pharmacy', 'doctor', 'fitness', 'gym',
  'entertainment', 'movies', 'music', 'games', 'sports', 'streaming',
  'education', 'school', 'course',
  'family', 'pet', 'charity', 'beauty',
  'business', 'work', 'office', 'supplies',
  'subscription', 'tax', 'bank', 'transfer', 'savings', 'wallet', 'cash',
];

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

  Future<void> _showCreateDialog(BuildContext context) async {
    final nameController = TextEditingController();
    var iconValue = 'restaurant';
    var colorValue = 'Azul';
    var selectedType = CategoryType.expense;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nueva categoría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await _showIconPicker(ctx);
                    if (picked != null) setState(() => iconValue = picked);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Icono',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          iconFromString(iconValue),
                          size: 20,
                          color: colorFromName(colorValue),
                        ),
                        const SizedBox(width: 12),
                        Text(iconValue, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final picked = await _showColorPicker(ctx);
                    if (picked != null) setState(() => colorValue = picked);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Color',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: colorFromName(colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(colorValue, style: const TextStyle(fontSize: 14)),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CategoryType>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
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
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    if (saved != true || !context.mounted) return;

    context.read<CategoriesBloc>().add(
      CategoriesCreateRequested(
        name: nameController.text.trim(),
        icon: iconValue,
        color: hexFromName(colorValue),
        type: selectedType,
      ),
    );
  }

  Future<String?> _showIconPicker(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.75;
    final maxWidth = media.size.width * 0.9;

    return showDialog<String>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Elegir icono',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: _iconNames.length,
                    itemBuilder: (context, index) {
                      final name = _iconNames[index];
                      final icon = iconFromString(name);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(ctx, name),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(icon, size: 22, color: cs.onSurface),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showColorPicker(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.75;
    final maxWidth = media.size.width * 0.9;

    final picked = await showDialog<int>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Elegir color',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: colorOptions.length,
                    itemBuilder: (context, index) {
                      final c = colorOptions[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(ctx, index),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: cs.outlineVariant.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: c.color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: cs.outlineVariant,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  c.name,
                                  style: const TextStyle(fontSize: 11),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (picked != null && picked < colorOptions.length) {
      return colorOptions[picked].name;
    }
    return null;
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
              onTap: () => _showCreateDialog(context),
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
