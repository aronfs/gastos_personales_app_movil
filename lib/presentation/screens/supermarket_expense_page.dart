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
import 'package:gastos_personales/presentation/screens/widgets/amount_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/cart_product_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/form_field_row.dart';
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

class _SupermarketExpenseViewState extends State<_SupermarketExpenseView> {
  final _descController = TextEditingController(text: 'Compra supermercado');

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _pickCategory(BuildContext context, List<Category> categories) async {
    final picked = await showModalBottomSheet<Category>(
      context: context,
      builder: (ctx) => ListView(
        children: categories
            .map((c) => ListTile(
                  title: Text(c.name),
                  onTap: () => Navigator.pop(ctx, c),
                ))
            .toList(),
      ),
    );
    if (picked != null && context.mounted) {
      context.read<SupermarketFormBloc>().add(SupermarketFormCategorySelected(picked));
    }
  }

  void _pickProduct(BuildContext context, List<Product> availableProducts) async {
    final picked = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Productos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.qr_code_scanner, size: 18, color: Color(0xFF673AB7)),
                          label: const Text('Escanear', style: TextStyle(fontSize: 13, color: Color(0xFF673AB7))),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pushNamed(context, scanBarcode).then((_) {
                              if (context.mounted) {
                                context.read<SupermarketFormBloc>().add(SupermarketFormFetchRequested());
                              }
                            });
                          },
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Crear', style: TextStyle(fontSize: 13)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pushNamed(context, newProduct).then((_) {
                              if (context.mounted) {
                                context.read<SupermarketFormBloc>().add(SupermarketFormFetchRequested());
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (availableProducts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No hay productos en esta categoría.'),
                )
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: availableProducts
                        .map((p) => ListTile(
                              title: Text(p.name),
                              subtitle: Text('\$ ${p.unitPrice.toStringAsFixed(2)}'),
                              onTap: () => Navigator.pop(ctx, p),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (picked != null && context.mounted) {
      context.read<SupermarketFormBloc>().add(SupermarketFormProductAdded(picked, 1));
    }
  }

  void _editDescription(BuildContext context) async {
    final controller = TextEditingController(text: _descController.text);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Descripción'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Compra Supermaxi'),
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
    );
    if (saved == true) {
      setState(() {
        _descController.text = controller.text;
      });
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
          categoryName = state.selectedCategory?.name ?? 'Seleccionar';
          cart = state.cart;
          availableProducts = state.availableProducts;
          categories = state.categories;
          baseCupo = state.baseCupo;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
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
                  amountColor: (baseCupo - total) < 0 ? const Color(0xFFE53935) : const Color(0xFF1A1A2E),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Total carrito: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FormFieldRow(
                  icon: Icons.shopping_cart_outlined,
                  iconBackgroundColor: const Color(0xFFFCEDD3),
                  iconColor: const Color(0xFFC8923B),
                  label: 'Categoría',
                  value: categoryName,
                  onTap: isLoading ? () {} : () => _pickCategory(context, categories),
                ),
                const SizedBox(height: 12),
                FormFieldRow(
                  icon: Icons.calendar_today_outlined,
                  iconBackgroundColor: const Color(0xFFDCE6FB),
                  iconColor: const Color(0xFF2962FF),
                  label: 'Fecha',
                  value: 'Hoy',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                FormFieldRow(
                  icon: Icons.description_outlined,
                  iconBackgroundColor: const Color(0xFFD7F2EC),
                  iconColor: const Color(0xFF1FAE8E),
                  label: 'Descripción',
                  value: _descController.text.isEmpty ? 'Ninguna' : _descController.text,
                  onTap: isLoading ? () {} : () => _editDescription(context),
                ),
                const SizedBox(height: 24),
                SectionHeaderWithAction(
                  title: 'Productos',
                  actionLabel: '+ Agregar',
                  onActionTap: isLoading ? () {} : () => _pickProduct(context, availableProducts),
                ),
                const SizedBox(height: 12),
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
                  color: const Color(0xFF2962FF),
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
