import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/layers/categories/data/categories_repository_impl.dart';
import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/get_categories.dart';
import 'package:gastos_personales/layers/incomes/data/incomes_repository_impl.dart';
import 'package:gastos_personales/layers/incomes/data/source/network/incomes_api.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/create_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/delete_income.dart';
import 'package:gastos_personales/layers/incomes/domain/usecase/update_income.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/presentation/screens/bloc/income_form/income_form_bloc.dart';
import 'package:gastos_personales/presentation/screens/widgets/amount_header.dart';
import 'package:gastos_personales/presentation/screens/widgets/destructive_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/inline_calendar_picker.dart';
import 'package:gastos_personales/presentation/screens/widgets/primary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/secondary_action_button.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';
import 'package:gastos_personales/util/color_helper.dart';
import 'package:gastos_personales/util/icon_helper.dart';
import 'package:gastos_personales/util/transaction_ui_helper.dart';
import 'package:gastos_personales/navigation/route.dart';

class NewIncomePage extends StatefulWidget {
  final Movement? income;

  const NewIncomePage({super.key, this.income});

  @override
  State<NewIncomePage> createState() => _NewIncomePageState();
}

class _NewIncomePageState extends State<NewIncomePage> {
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late DateTime _selectedDate;
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _loadingCategories = true;
  bool _showCategories = false;

  bool get _isEditing => widget.income != null;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.income?.amount.toStringAsFixed(2) ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.income?.description ?? '',
    );
    _amountController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _selectedDate = widget.income != null
        ? DateTime.tryParse(widget.income!.transactionDate) ?? DateTime.now()
        : DateTime.now();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await GetCategories(
        CategoriesRepositoryImpl(CategoriesApiImpl()),
      )(type: CategoryType.income);

      Category? selected;
      if (widget.income != null) {
        for (final c in categories) {
          if (c.id == widget.income!.category.id) {
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

  void _submit(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.enterValidAmount)),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.selectSourceError)),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.enterDescriptionIncome)),
      );
      return;
    }

    context.read<IncomeFormBloc>().add(
      IncomeFormSubmitRequested(
        id: widget.income?.id,
        amount: amount,
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory!.id,
        transactionDate: formatApiDate(_selectedDate),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = IncomesRepositoryImpl(IncomesApiImpl());

    return BlocProvider(
      create: (_) => IncomeFormBloc(
        CreateIncome(repo),
        UpdateIncome(repo),
        DeleteIncome(repo),
      ),
      child: BlocConsumer<IncomeFormBloc, IncomeFormState>(
        listener: (context, state) {
          if (state is IncomeFormSuccess || state is IncomeFormDeleted) {
            Navigator.pushNamedAndRemoveUntil(context, home, (route) => false);
          } else if (state is IncomeFormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final loc = AppLocalizations.of(context)!;
          final loading = state is IncomeFormLoading;
          final cs = Theme.of(context).colorScheme;

          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  SettingsAppBar(
                    title: _isEditing ? loc.editIncome : loc.newIncome,
                  ),
                  const SizedBox(height: 24),
                  AmountHeader(
                    label: loc.incomeLabel,
                    prefixSign: '+ \$',
                    amountText: _amountController.text.isEmpty
                        ? '0.00'
                        : _amountController.text,
                    amountColor: cs.tertiary,
                  ),
                  const SizedBox(height: 28),

                  // ── Selector de fuente expandible ──
                  _buildCategorySectionHeader(cs),
                  const SizedBox(height: 8),
                  AnimatedCrossFade(
                    firstChild: _buildCategoryPreview(cs),
                    secondChild: _buildCategoryGrid(cs),
                    crossFadeState: _showCategories
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 280),
                    sizeCurve: Curves.easeInOut,
                  ),

                  const SizedBox(height: 24),

                  // ── Fecha (calendario inline) ──
                  InlineCalendarPicker(
                    label: loc.date,
                    selectedDate: _selectedDate,
                    icon: Icons.calendar_today_outlined,
                    iconBackgroundColor: cs.tertiary.withValues(alpha: 0.15),
                    iconColor: cs.tertiary,
                    enabled: !loading,
                    onDateChanged: (date) =>
                        setState(() => _selectedDate = date),
                  ),

                  const SizedBox(height: 24),

                  // ── Monto ──
                  TextFormField(
                    controller: _amountController,
                    enabled: !loading,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: loc.expenseAmount,
                      hintText: loc.hintAmount,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 10),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: cs.tertiary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: cs.tertiary,
                            ),
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: cs.outline),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Descripción ──
                  TextFormField(
                    controller: _descriptionController,
                    enabled: !loading,
                    decoration: InputDecoration(
                      labelText: loc.description,
                      hintText: loc.hintDescriptionIncome,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 14, right: 10),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.sell_outlined,
                            size: 20,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: cs.outline),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  const SizedBox(height: 28),
                  PrimaryActionButton(
                    label: loading
                        ? loc.savingDots
                        : (_isEditing
                            ? loc.updateIncome
                            : loc.saveIncome),
                    onPressed: loading ? null : () => _submit(context),
                  ),
                  const SizedBox(height: 8),
                  SecondaryActionButton(
                    label: loc.cancel,
                    onPressed: loading
                        ? null
                        : () => Navigator.of(context).maybePop(),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 8),
                    DestructiveActionButton(
                      label: loc.deleteIncomeAction,
                      onPressed: loading
                          ? null
                          : () => context.read<IncomeFormBloc>().add(
                              IncomeFormDeleteRequested(widget.income!.id),
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

  // ─────────────────────────────────────────────
  //  Category expandible selector
  // ─────────────────────────────────────────────

  Widget _buildCategorySectionHeader(ColorScheme cs) {
    final loc = AppLocalizations.of(context)!;
    final categoryColor = _selectedCategory != null
        ? colorFromHex(_selectedCategory!.color)
        : cs.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => setState(() {
          _showCategories = !_showCategories;
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _showCategories ? cs.primary : cs.outlineVariant,
              width: _showCategories ? 1.5 : 1,
            ),
            color: _showCategories
                ? cs.primary.withValues(alpha: 0.04)
                : cs.surfaceContainerLowest,
          ),
          child: Row(
            children: [
              Text(
                loc.incomeSource,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _showCategories ? cs.primary : cs.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              if (_selectedCategory != null)
                Text(
                  _selectedCategory!.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: categoryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: _showCategories ? 0.5 : 0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPreview(ColorScheme cs) {
    final loc = AppLocalizations.of(context)!;
    final categoryColor = _selectedCategory != null
        ? colorFromHex(_selectedCategory!.color)
        : cs.onSurfaceVariant;
    final iconName = _selectedCategory?.icon ?? 'default';
    final icon = iconFromString(iconName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: _loadingCategories
          ? Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  loc.loadingSources,
                  style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 16, color: categoryColor),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedCategory?.name ?? loc.selectSource,
                  style: TextStyle(
                    fontSize: 13,
                    color: _selectedCategory != null
                        ? cs.onSurface
                        : cs.onSurfaceVariant,
                    fontWeight: _selectedCategory != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryGrid(ColorScheme cs) {
    final loc = AppLocalizations.of(context)!;
    if (_categories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          color: cs.surfaceContainerLowest,
        ),
        child: Center(
          child: Text(
            loc.noSourcesAvailable,
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        color: cs.surfaceContainerLowest,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _categories.map((c) {
          final color = colorFromHex(c.color);
          final icon = iconFromString(c.icon);
          final isSelected = c.id == _selectedCategory?.id;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => setState(() {
                _selectedCategory = c;
                _showCategories = false;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.1)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(icon, size: 14, color: color),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? cs.primary : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
