import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';

class ReceiptEditPage extends StatefulWidget {
  final String imagePath;
  final String ocrText;
  final double? hintTotal;

  const ReceiptEditPage({
    super.key,
    required this.imagePath,
    required this.ocrText,
    this.hintTotal,
  });

  @override
  State<ReceiptEditPage> createState() => _ReceiptEditPageState();
}

class _ReceiptEditPageState extends State<ReceiptEditPage> {
  late final TextEditingController _totalController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _totalController = TextEditingController(
      text: widget.hintTotal != null ? widget.hintTotal!.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.reviewReceipt),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image preview
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(widget.imagePath),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: cs.surfaceContainerLowest,
                    ),
                    child: const Center(child: Icon(Icons.broken_image_outlined, size: 48)),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Total field
              TextFormField(
                controller: _totalController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: loc.detectedTotal,
                  hintText: loc.hintAmount,
                  prefixText: '\$ ',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return loc.enterTotal;
                  final parsed = double.tryParse(v.trim().replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) return loc.enterValidTotal;
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // OCR text preview
              Text(
                loc.detectedText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurfaceVariant,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
                  color: cs.surfaceContainerLowest,
                ),
                child: Text(
                  widget.ocrText.isEmpty ? loc.noTextDetected : widget.ocrText,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurface,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final total = double.tryParse(_totalController.text.trim().replaceAll(',', '.'));
                  if (total != null) {
                    Navigator.pop(context, {
                      'imagePath': widget.imagePath,
                      'ocrText': widget.ocrText,
                      'total': total,
                    });
                  }
                },
                icon: const Icon(Icons.check),
                label: Text(loc.confirmReceipt),
              ),

              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(loc.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
