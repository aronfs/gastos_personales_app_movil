import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/presentation/screens/bloc/categories/categories_bloc.dart';
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

  Future<String?> _pickIcon() async {
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

  Future<String?> _pickColor() async {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesBloc, CategoriesState>(
      listener: (context, state) {
        if (state is CategoriesUpdateSuccess) {
          _hasSaved = true;
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Categoría actualizada correctamente.'),
              backgroundColor: Color(0xFF43A047),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is CategoriesError) {
          if (!mounted) return;
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
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
          title: const Text('Editar categoría'),
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
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'El nombre es obligatorio' : null,
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _isSaving ? null : () async {
                    final picked = await _pickIcon();
                    if (picked != null) setState(() => _iconValue = picked);
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
                          iconFromString(_iconValue),
                          size: 24,
                          color: colorFromName(_colorValue),
                        ),
                        const SizedBox(width: 12),
                        Text(_iconValue, style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _isSaving ? null : () async {
                    final picked = await _pickColor();
                    if (picked != null) setState(() => _colorValue = picked);
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
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                          color: colorFromName(_colorValue),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(_colorValue, style: const TextStyle(fontSize: 14)),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSaving ? null : _onSave,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
