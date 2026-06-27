import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/expenses/data/expenses_repository_impl.dart';
import 'package:gastos_personales/layers/expenses/data/source/network/expenses_api.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/create_supermarket_expense.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/get_products.dart';
import 'package:gastos_personales/layers/dashboard/data/dashboard_repository_impl.dart';
import 'package:gastos_personales/layers/dashboard/data/source/network/dashboard_api.dart';
import 'package:gastos_personales/layers/dashboard/domain/usecase/get_dashboard.dart';
import 'package:gastos_personales/presentation/screens/bloc/supermarket_form/supermarket_form_bloc.dart';
import 'package:gastos_personales/presentation/screens/select_product_page.dart';
import 'package:gastos_personales/presentation/screens/widgets/amount_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/cart_product_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/inline_editable_field_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/section_header_with_action.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';
import 'package:gastos_personales/navigation/route.dart';

class SupermarketExpensePage extends StatelessWidget {
  const SupermarketExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupermarketFormBloc(
        GetCategories(CategoriesRepositoryImpl(CategoriesApiImpl())),
        GetProducts(ProductsRepositoryImpl(ProductsApiImpl())),
        CreateSupermarketExpense(ExpensesRepositoryImpl(ExpensesApiImpl())),
        GetDashboard(DashboardRepositoryImpl(DashboardApiImpl())),
      )..add(SupermarketFormFetchRequested()),
      child: const _SupermarketExpenseView(),
    );
  }
}

class _SupermarketExpenseView extends StatefulWidget {
  const _SupermarketExpenseView();

  @override
  State<_SupermarketExpenseView> createState() => _SupermarketExpenseViewState();
}

class _SupermarketExpenseViewState extends State<_SupermarketExpenseView>
    with SingleTickerProviderStateMixin {
  final _descController = TextEditingController(text: 'Compra supermercado');
  bool _categoryExpanded = false;
  late AnimationController _animCtrl;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _descController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggleCategory(List<Category> categories) {
    if (categories.isEmpty) return;
    setState(() {
      _categoryExpanded = !_categoryExpanded;
      if (_categoryExpanded) {
        _animCtrl.forward();
      } else {
        _animCtrl.reverse();
      }
    });
  }

  void _selectCategory(Category category, BuildContext context) {
    _animCtrl.reverse();
    setState(() => _categoryExpanded = false);
    context.read<SupermarketFormBloc>().add(SupermarketFormCategorySelected(category));
  }

  Future<void> _pickProduct(BuildContext context, List<Product> availableProducts) async {
    final picked = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectProductPage(initialProducts: availableProducts),
      ),
    );

    if (picked != null && context.mounted) {
      context.read<SupermarketFormBloc>().add(SupermarketFormProductAdded(picked, 1));
    }
  }

  void _submit(BuildContext context) {
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una descripción')),
      );
      return;
    }

    context.read<SupermarketFormBloc>().add(
      SupermarketFormSubmitRequested(
        description: _descController.text.trim(),
        transactionDate: formatApiDate(DateTime.now()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return BlocConsumer<SupermarketFormBloc, SupermarketFormState>(
      listener: (context, state) {
        if (state is SupermarketFormSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
        } else if (state is SupermarketFormFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is SupermarketFormLoading || state is SupermarketFormSubmitting;
        double total = 0.0;
        String categoryName = 'Cargando...';
        List<CartItem> cart = [];
        List<Product> availableProducts = [];
        List<Category> categories = [];
        double baseCupo = 0.0;

        if (state is SupermarketFormLoaded) {
          total = state.cart.fold(0.0, (sum, item) => sum + item.subtotal);
          categoryName = state.selectedCategory?.name ?? 'Seleccionar categoría';
          cart = state.cart;
          availableProducts = state.availableProducts;
          categories = state.categories;
          baseCupo = state.baseCupo;
        }

        return Scaffold(
          backgroundColor: cs.surface,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const SettingsAppBar(title: 'Gasto supermercado'),
                const SizedBox(height: 20),
                AmountHeader(
                  label: 'Cupo restante',
                  prefixSign: '\$',
                  amountText: (baseCupo - total).toStringAsFixed(2),
                  amountColor: (baseCupo - total) < 0 ? cs.error : cs.onSurface,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Total carrito: \$${total.toStringAsFixed(2)}',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _FieldCard(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Categoría',
                  value: categoryName,
                  isExpanded: _categoryExpanded,
                  isLoading: isLoading,
                  onTap: isLoading ? null : () => _toggleCategory(categories),
                ),
                SizeTransition(
                  sizeFactor: _expandAnim,
                  alignment: Alignment.topCenter,
                  child: _CategoryList(
                    categories: categories,
                    selectedId: state is SupermarketFormLoaded
                        ? state.selectedCategory?.id
                        : null,
                    onSelect: (c) => _selectCategory(c, context),
                  ),
                ),
                const SizedBox(height: 12),

                InlineEditableFieldRow(
                  icon: Icons.description_outlined,
                  label: 'Descripción',
                  controller: _descController,
                  hintText: 'Compra Supermaxi',
                  enabled: !isLoading,
                ),
                const SizedBox(height: 24),

                SectionHeaderWithAction(
                  title: 'Productos',
                  actionLabel: '+ Agregar',
                  onActionTap: isLoading ? () {} : () => _pickProduct(context, availableProducts),
                ),
                const SizedBox(height: 12),

                if (cart.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Presiona "+ Agregar" para añadir productos',
                        style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  for (int i = 0; i < cart.length; i++) ...[
                    CartProductRow(
                      item: cart[i],
                      onIncrement: isLoading
                          ? () {}
                          : () => context.read<SupermarketFormBloc>().add(
                                SupermarketFormProductUpdated(i, cart[i].quantity + 1),
                              ),
                      onDecrement: isLoading
                          ? () {}
                          : () {
                              if (cart[i].quantity > 1) {
                                context.read<SupermarketFormBloc>().add(
                                  SupermarketFormProductUpdated(i, cart[i].quantity - 1),
                                );
                              } else {
                                context.read<SupermarketFormBloc>().add(
                                  SupermarketFormProductRemoved(i),
                                );
                              }
                            },
                    ),
                    if (i != cart.length - 1) const SizedBox(height: 10),
                  ],
                const SizedBox(height: 32),
                PrimaryActionButton(
                  label: state is SupermarketFormSubmitting ? 'Guardando...' : 'Guardar',
                  color: cs.primary,
                  onPressed: isLoading ? null : () => _submit(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isExpanded;
  final bool isLoading;
  final VoidCallback? onTap;

  const _FieldCard({
    required this.icon,
    required this.label,
    required this.value,
    this.isExpanded = false,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: cs.outlineVariant, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 20, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      style: tt.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 22,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<Category> onSelect;

  const _CategoryList({
    required this.categories,
    this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            InkWell(
              borderRadius: i == 0
                  ? const BorderRadius.vertical(top: Radius.circular(17))
                  : i == categories.length - 1
                      ? const BorderRadius.vertical(bottom: Radius.circular(17))
                      : null,
              onTap: () => onSelect(categories[i]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: cs.secondaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.category_outlined,
                        size: 18,
                        color: cs.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        categories[i].name,
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    if (categories[i].id == selectedId)
                      Icon(Icons.check, size: 20, color: cs.primary),
                  ],
                ),
              ),
            ),
            if (i != categories.length - 1)
              Divider(height: 1, indent: 64, color: cs.outlineVariant),
          ],
        ],
      ),
    );
  }
}
