import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/create_product.dart';
import 'package:gastos_personales/presentation/screens/bloc/product_form/product_form_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/icon_circle_avatar.dart';
import 'package:gastos_personales/presentation/screens/widgets/inline_input_field.dart';
import 'package:gastos_personales/presentation/screens/widgets/labeled_text_field.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/product_preview_card.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({super.key});

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  
  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_rebuild);
    _descController.addListener(_rebuild);
    _priceController.addListener(_rebuild);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      debugPrint('Loading categories in NewProductPage...');
      final categories = await GetCategories(
        CategoriesRepositoryImpl(CategoriesApiImpl()),
      )(type: CategoryType.expense);
      
      debugPrint('Loaded categories count: ${categories.length}');

      Category? selected;
      if (categories.isNotEmpty) {
        selected = categories.cast<Category>().firstWhere(
          (c) => c.name.toLowerCase().contains('supermercado'),
          orElse: () => categories.first,
        );
        debugPrint('Selected category: ${selected.name}');
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _selectedCategory = selected;
          _loadingCategories = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error loading categories: $e');
      debugPrint(stackTrace.toString());
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

  Future<void> _pickCategory() async {
    if (_categories.isEmpty) {
      setState(() => _loadingCategories = true);
      await _loadCategories();
      if (_categories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay categorías disponibles o no se cargaron correctamente')),
        );
        return;
      }
    }

    final picked = await showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Seleccionar Categoría', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: _categories
                      .map(
                        (c) => ListTile(
                          leading: Icon(Icons.category, color: Color(int.parse(c.color.replaceFirst('#', '0xFF')))),
                          title: Text(c.name),
                          onTap: () => Navigator.pop(ctx, c),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _selectedCategory = picked);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String get _priceLabel {
    final raw = _priceController.text.trim();
    final value = double.tryParse(raw);
    if (value == null) return '\$ 0.00';
    return '\$ ${value.toStringAsFixed(2)}';
  }

  void _submit(BuildContext context) {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un nombre')),
      );
      return;
    }
    final rawPrice = _priceController.text.replaceAll(',', '.');
    final price = double.tryParse(rawPrice);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un precio válido')),
      );
      return;
    }

    context.read<ProductFormBloc>().add(
      ProductFormSubmitRequested(
        categoryId: _selectedCategory!.id,
        name: name,
        description: _descController.text.trim(),
        unitPrice: price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ProductsRepositoryImpl(ProductsApiImpl());

    return BlocProvider(
      create: (_) => ProductFormBloc(CreateProduct(repo)),
      child: BlocConsumer<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          if (state is ProductFormSuccess) {
            Navigator.pop(context, true);
          } else if (state is ProductFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final loading = state is ProductFormLoading;
          final categoryName = _loadingCategories
              ? 'Cargando...'
              : (_selectedCategory?.name ?? 'Seleccionar');

          return Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  const SettingsAppBar(title: 'Nuevo producto'),
                  const SizedBox(height: 24),
                  const Center(
                    child: IconCircleAvatar(
                      icon: Icons.inventory_2_outlined,
                      backgroundColor: Color(0xFF2962FF),
                      caption: 'Producto del catálogo',
                    ),
                  ),
                  const SizedBox(height: 28),
                  LabeledTextField(
                    label: 'Nombre',
                    controller: _nameController,
                    hintText: 'Ej. Arroz',
                    prefixIcon: Icons.sell_outlined,
                    prefixIconColor: const Color(0xFF9A9DB0),
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Descripción',
                    controller: _descController,
                    hintText: 'Ej. Arroz integral 1kg',
                    prefixIcon: Icons.description_outlined,
                    prefixIconColor: const Color(0xFF9A9DB0),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PRECIO UNITARIO',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9A9DB0),
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFEEF0F4), width: 1),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 16, color: Color(0xFF2E9E4F)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _priceController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                        ],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A2E),
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: '0.00',
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CATEGORÍA',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF9A9DB0),
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InlineInputField(
                              icon: Icons.shopping_cart_outlined,
                              iconColor: const Color(0xFFC8923B),
                              value: categoryName,
                              onTap: loading ? null : _pickCategory,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ProductPreviewCard(
                    name: _nameController.text.isEmpty ? 'Nombre' : _nameController.text,
                    description: _descController.text.isEmpty ? 'Descripción' : _descController.text,
                    priceLabel: _priceLabel,
                  ),
                  const SizedBox(height: 24),
                  PrimaryActionButton(
                    label: loading ? 'Creando...' : 'Crear producto',
                    color: const Color(0xFF2962FF),
                    onPressed: loading ? null : () => _submit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
