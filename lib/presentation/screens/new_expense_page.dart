import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/expenses/data/expenses_repository_impl.dart';
import 'package:gastos_personales/layers/expenses/data/source/network/expenses_api.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/create_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/delete_expense.dart';
import 'package:gastos_personales/layers/expenses/domain/usecase/update_expense.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/presentation/screens/bloc/expense_form/expense_form_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/amount_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/dashed_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/destructive_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/form_field_row.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/secondary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/util/color_helper.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';
import 'package:gastos_personales/navigation/route.dart';

class NewExpensePage extends StatefulWidget {
  final Movement? expense;

  const NewExpensePage({super.key, this.expense});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _loadingCategories = true;

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.expense?.amount.toStringAsFixed(2) ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.expense?.description ?? '',
    );
    _selectedDate = widget.expense != null
        ? DateTime.tryParse(widget.expense!.transactionDate) ?? DateTime.now()
        : DateTime.now();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await GetCategories(
        CategoriesRepositoryImpl(CategoriesApiImpl()),
      )(type: CategoryType.expense);

      Category? selected;
      if (widget.expense != null) {
        for (final c in categories) {
          if (c.id == widget.expense!.category.id) {
            selected = c;
            break;
          }
        }
        selected ??= categories.isNotEmpty ? categories.first : null;
      } else if (categories.isNotEmpty) {
        selected = categories.first;
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _selectedCategory = selected;
          _loadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickCategory() async {
    if (_categories.isEmpty) return;

    final picked = await showModalBottomSheet<Category>(
      context: context,
      builder: (ctx) => ListView(
        children: _categories
            .map(
              (c) => ListTile(
                title: Text(c.name),
                onTap: () => Navigator.pop(ctx, c),
              ),
            )
            .toList(),
      ),
    );
    if (picked != null) setState(() => _selectedCategory = picked);
  }

  Future<void> _editAmount() async {
    final controller = TextEditingController(text: _amountController.text);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monto'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(prefixText: '\$ '),
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
    if (saved == true) setState(() => _amountController.text = controller.text);
  }

  Future<void> _editDescription() async {
    final controller = TextEditingController(text: _descriptionController.text);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Descripción'),
        content: TextField(controller: controller),
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
      setState(() => _descriptionController.text = controller.text);
    }
  }

  void _submit(BuildContext context) {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un monto válido')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una categoría')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una descripción')),
      );
      return;
    }

    context.read<ExpenseFormBloc>().add(
      ExpenseFormSubmitRequested(
        id: widget.expense?.id,
        amount: amount,
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory!.id,
        transactionDate: formatApiDate(_selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ExpensesRepositoryImpl(ExpensesApiImpl());

    return BlocProvider(
      create: (_) => ExpenseFormBloc(
        CreateExpense(repo),
        UpdateExpense(repo),
        DeleteExpense(repo),
      ),
      child: BlocConsumer<ExpenseFormBloc, ExpenseFormState>(
        listener: (context, state) {
          if (state is ExpenseFormSuccess || state is ExpenseFormDeleted) {
            Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
          } else if (state is ExpenseFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final loading = state is ExpenseFormLoading;
          final categoryColor = _selectedCategory != null
              ? colorFromHex(_selectedCategory!.color)
              : const Color(0xFFC8923B);

          return Scaffold(
            backgroundColor: const Color(0xFFF5F6FA),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  SettingsAppBar(
                    title: _isEditing ? 'Editar gasto' : 'Nuevo gasto',
                  ),
                  const SizedBox(height: 24),
                  AmountHeader(
                    label: 'Monto',
                    prefixSign: '\$',
                    amountText: _amountController.text.isEmpty
                        ? '0.00'
                        : _amountController.text,
                  ),
                  const SizedBox(height: 28),
                  FormFieldRow(
                    icon: Icons.local_cafe_outlined,
                    iconBackgroundColor: categoryColor.withValues(alpha: 0.15),
                    iconColor: categoryColor,
                    label: 'Categoría',
                    value: _loadingCategories
                        ? 'Cargando...'
                        : (_selectedCategory?.name ?? 'Seleccionar'),
                    onTap: loading ? null : _pickCategory,
                  ),
                  const SizedBox(height: 12),
                  FormFieldRow(
                    icon: Icons.calendar_today_outlined,
                    iconBackgroundColor: const Color(0xFFDCE6FB),
                    iconColor: const Color(0xFF2962FF),
                    label: 'Fecha',
                    value: formatDisplayDate(_selectedDate),
                    onTap: loading ? null : _pickDate,
                  ),
                  const SizedBox(height: 12),
                  FormFieldRow(
                    icon: Icons.sell_outlined,
                    iconBackgroundColor: const Color(0xFFD7F2EC),
                    iconColor: const Color(0xFF1FAE8E),
                    label: 'Descripción',
                    value: _descriptionController.text.isEmpty
                        ? 'Agregar descripción'
                        : _descriptionController.text,
                    onTap: loading ? null : _editDescription,
                  ),
                  const SizedBox(height: 12),
                  FormFieldRow(
                    icon: Icons.attach_money,
                    iconBackgroundColor: const Color(0xFFFCEDD3),
                    iconColor: const Color(0xFFC8923B),
                    label: 'Monto',
                    value: _amountController.text.isEmpty
                        ? '\$ 0.00'
                        : '\$ ${_amountController.text}',
                    onTap: loading ? null : _editAmount,
                  ),
                  const SizedBox(height: 16),
                  DashedActionButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'Adjuntar comprobante',
                    onPressed: () {},
                  ),
                  const SizedBox(height: 28),
                  PrimaryActionButton(
                    label: loading
                        ? 'Guardando...'
                        : (_isEditing ? 'Actualizar gasto' : 'Guardar gasto'),
                    color: const Color(0xFF2962FF),
                    onPressed: loading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: 8),
                  SecondaryActionButton(
                    label: 'Cancelar',
                    onPressed: loading
                        ? null
                        : () => Navigator.of(context).maybePop(),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 8),
                    DestructiveActionButton(
                      label: 'Eliminar gasto',
                      onPressed: loading
                          ? null
                          : () => context.read<ExpenseFormBloc>().add(
                              ExpenseFormDeleteRequested(widget.expense!.id),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
