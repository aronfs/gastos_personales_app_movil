import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/create_product.dart';
import 'package:gastos_personales/layers/scanner/domain/entity/product_scan_result.dart';
import 'package:gastos_personales/presentation/screens/bloc/product_form/product_form_bloc.dart';

class ScanConfirmPage extends StatelessWidget {
  final ProductScanResult scanResult;
  final String categoryId;

  const ScanConfirmPage({
    super.key,
    required this.scanResult,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFormBloc(
        CreateProduct(ProductsRepositoryImpl(ProductsApiImpl())),
      ),
      child: _ScanConfirmForm(
        scanResult: scanResult,
        categoryId: categoryId,
      ),
    );
  }
}

class _ScanConfirmForm extends StatefulWidget {
  final ProductScanResult scanResult;
  final String categoryId;

  const _ScanConfirmForm({
    required this.scanResult,
    required this.categoryId,
  });

  @override
  State<_ScanConfirmForm> createState() => _ScanConfirmFormState();
}

class _ScanConfirmFormState extends State<_ScanConfirmForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _presentationController;
  late final TextEditingController _priceController;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.scanResult.name);
    _presentationController = TextEditingController(
      text: widget.scanResult.presentation,
    );
    _priceController = TextEditingController(
      text: widget.scanResult.price.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _presentationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_hasSaved) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un nombre')),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;

    final editedResult = widget.scanResult.copyWith(
      name: name,
      presentation: _presentationController.text.trim(),
      price: price,
    );

    _hasSaved = true;

    context.read<ProductFormBloc>().add(
      ProductFormSubmitRequested(
        categoryId: widget.categoryId,
        name: editedResult.name,
        description: editedResult.presentation.isNotEmpty
            ? editedResult.presentation
            : 'Detectado por OCR',
        unitPrice: editedResult.price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductFormBloc, ProductFormState>(
      listener: (context, state) {
        if (state is ProductFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto guardado correctamente.'),
              backgroundColor: Color(0xFF43A047),
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProductFormFailure) {
          _hasSaved = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductFormLoading;
        final cs = Theme.of(context).colorScheme;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Confirmar datos'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Revisa los datos detectados por el escáner.',
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del producto',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _presentationController,
                  decoration: const InputDecoration(
                    labelText: 'Presentación',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Precio',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: isLoading ? null : _onSave,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Guardar producto'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(context, false),
                  child: const Text('Volver a escanear'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
