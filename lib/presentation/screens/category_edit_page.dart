import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/presentation/screens/bloc/categories/categories_bloc.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/util/color_helper.dart';
import 'package:gastos_personales/util/icon_helper.dart';

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

class CategoryEditPage extends StatefulWidget {
  final Category category;

  const CategoryEditPage({super.key, required this.category});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  late final TextEditingController _nameController;
  late String _iconValue;
  late String _colorValue;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _hasSaved = false;
  bool _showIcons = false;
  bool _showColors = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _iconValue = widget.category.icon;
    _colorValue = nameFromHex(widget.category.color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving || _hasSaved) return;

    setState(() => _isSaving = true);

    if (!mounted) return;
    context.read<CategoriesBloc>().add(
      CategoriesUpdateRequested(
        id: widget.category.id,
        name: _nameController.text.trim(),
        icon: _iconValue,
        color: hexFromName(_colorValue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesUpdateSuccess) {
          _hasSaved = true;
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.categoryUpdateSuccess),
              backgroundColor: cs.tertiary,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is CategoriesError) {
          if (!mounted) return;
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: cs.error,
            ),
          );
          if (state.message.contains('Sesión expirada') && mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/signin',
              (route) => false,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.editCategory),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: loc.categoryName,
                    border: OutlineInputBorder(borderSide: BorderSide(color: cs.outline)),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? loc.categoryNameRequired : null,
                ),
                const SizedBox(height: 24),

                // ── Selector de ícono expandible ──
                _buildSectionHeader(
                  cs: cs,
                  title: loc.iconLabel,
                  trailing: Text(
                    _iconValue,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => setState(() {
                    _showIcons = !_showIcons;
                    if (_showIcons) _showColors = false;
                  }),
                  isExpanded: _showIcons,
                ),
                const SizedBox(height: 8),
                AnimatedCrossFade(
                  firstChild: _buildIconPreview(cs),
                  secondChild: _buildIconGrid(cs),
                  crossFadeState: _showIcons
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 280),
                  sizeCurve: Curves.easeInOut,
                ),

                const SizedBox(height: 24),

                // ── Selector de color expandible ──
                _buildSectionHeader(
                  cs: cs,
                  title: loc.colorLabel,
                  trailing: Text(
                    _colorValue,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorFromName(_colorValue),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => setState(() {
                    _showColors = !_showColors;
                    if (_showColors) _showIcons = false;
                  }),
                  isExpanded: _showColors,
                ),
                const SizedBox(height: 8),
                AnimatedCrossFade(
                  firstChild: _buildColorPreview(cs),
                  secondChild: _buildColorGrid(cs),
                  crossFadeState: _showColors
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 280),
                  sizeCurve: Curves.easeInOut,
                ),

                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSaving ? null : _onSave,
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.surfaceContainerLowest,
                          ),
                        )
                      : Text(loc.saveChanges),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Section header
  // ─────────────────────────────────────────────

  Widget _buildSectionHeader({
    required ColorScheme cs,
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
    required bool isExpanded,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isExpanded ? cs.primary : cs.outlineVariant,
              width: isExpanded ? 1.5 : 1,
            ),
            color: isExpanded
                ? cs.primary.withValues(alpha: 0.04)
                : cs.surfaceContainerLowest,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isExpanded ? cs.primary : cs.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),
              trailing,
              const SizedBox(width: 8),
              AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
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

  // ─────────────────────────────────────────────
  //  Vista previa compacta
  // ─────────────────────────────────────────────

  Widget _buildIconPreview(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(iconFromString(_iconValue), size: 20, color: cs.onSurface),
          const SizedBox(width: 10),
          Text(
            _iconValue,
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPreview(ColorScheme cs) {
    final c = colorFromName(_colorValue);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: Border.all(color: cs.outlineVariant),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _colorValue,
            style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Grids expandidos
  // ─────────────────────────────────────────────

  Widget _buildIconGrid(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        color: cs.surfaceContainerLowest,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: _iconNames.length,
        itemBuilder: (context, index) {
          final name = _iconNames[index];
          final icon = iconFromString(name);
          final isSelected = name == _iconValue;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _isSaving
                  ? null
                  : () => setState(() {
                        _iconValue = name;
                        _showIcons = false;
                      }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.outlineVariant.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? cs.primary.withValues(alpha: 0.1)
                      : null,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: isSelected ? cs.primary : cs.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorGrid(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        color: cs.surfaceContainerLowest,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.0,
        ),
        itemCount: colorOptions.length,
        itemBuilder: (context, index) {
          final c = colorOptions[index];
          final isSelected = c.name == _colorValue;
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _isSaving
                  ? null
                  : () => setState(() {
                        _colorValue = c.name;
                        _showColors = false;
                      }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? cs.primary
                        : cs.outlineVariant.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: c.color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cs.outlineVariant,
                          width: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.name,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? cs.primary : cs.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
