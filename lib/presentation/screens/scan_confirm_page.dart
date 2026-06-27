import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/products/data/products_repository_impl.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/usecase/create_product.dart';
import 'package:gastos_personales/layers/scanner/domain/entity/product_scan_result.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;

    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.enterName)),
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
            : loc.detectedByOcr,
        unitPrice: editedResult.price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return BlocConsumer<ProductFormBloc, ProductFormState>(
      listener: (context, state) {
        if (state is ProductFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.productSaved),
              backgroundColor: cs.tertiary,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ProductFormFailure) {
          _hasSaved = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: cs.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ProductFormLoading;

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.confirmDataTitle),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.confirmDataMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: loc.productNameLabel,
                    border: OutlineInputBorder(borderSide: BorderSide(color: cs.outline)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _presentationController,
                  decoration: InputDecoration(
                    labelText: loc.presentationLabel,
                    border: OutlineInputBorder(borderSide: BorderSide(color: cs.outline)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: loc.priceLabel,
                    prefixText: '\$ ',
                    border: OutlineInputBorder(borderSide: BorderSide(color: cs.outline)),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: isLoading ? null : _onSave,
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.surfaceContainerLowest,
                          ),
                        )
                      : Text(loc.saveProduct),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pop(context, false),
                  child: Text(loc.rescan),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
