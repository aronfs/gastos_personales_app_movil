import 'package:flutter/material.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/get_products.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';

class SelectProductPage extends StatefulWidget {
  final List<Product> initialProducts;

  const SelectProductPage({super.key, required this.initialProducts});

  @override
  State<SelectProductPage> createState() => _SelectProductPageState();
}

class _SelectProductPageState extends State<SelectProductPage> {
  late List<Product> _products;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _products = List.from(widget.initialProducts);
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) return _products;
    return _products.where((p) {
      return p.name.toLowerCase().contains(_searchQuery) ||
          p.description.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _refreshProducts() async {
    try {
      final categories = await GetCategories(
        CategoriesRepositoryImpl(CategoriesApiImpl()),
      )(type: CategoryType.expense);
      final supermercado = categories.firstWhere(
        (c) => c.name.toLowerCase().contains('supermercado'),
        orElse: () => categories.first,
      );
      final fresh = await GetProducts(
        ProductsRepositoryImpl(ProductsApiImpl()),
      )(categoryId: supermercado.id);
      if (mounted) setState(() => _products = fresh);
    } catch (_) {}
  }

  Future<void> _handleCreate() async {
    final created = await Navigator.pushNamed(context, newProduct);
    if (created == true) {
      await _refreshProducts();
    }
  }

  Future<void> _handleScan() async {
    await Navigator.pushNamed(context, scanBarcode);
    await _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SettingsAppBar(title: 'Agregar producto'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: cs.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _ActionChip(
                    icon: Icons.add,
                    label: 'Crear',
                    onTap: _handleCreate,
                  ),
                  const SizedBox(width: 10),
                  _ActionChip(
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear',
                    onTap: _handleScan,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        _searchQuery.isEmpty
                            ? 'No hay productos disponibles'
                            : 'Sin resultados para "$_searchQuery"',
                        style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final product = filtered[index];
                        return _ProductCard(
                          product: product,
                          onTap: () => Navigator.pop(context, product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.primaryContainer,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: cs.onPrimaryContainer),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: cs.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: cs.onPrimaryContainer,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.description,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '\$${product.unitPrice.toStringAsFixed(2)}',
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.add_circle, color: cs.primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
