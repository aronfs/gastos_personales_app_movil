import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/receipt_scanner/data/repository_impl/receipt_repository_impl.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';
import 'package:gastos_personales/presentation/screens/bloc/receipt_scanner/receipt_scanner_bloc.dart';
import 'package:gastos_personales/presentation/screens/bloc/receipt_scanner/receipt_scanner_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/receipt_scanner/receipt_scanner_state.dart';
import 'package:gastos_personales/presentation/screens/new_expense_page.dart';
import 'package:gastos_personales/presentation/screens/receipt_capture_page.dart';
import 'package:gastos_personales/presentation/screens/receipt_edit_page.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
import 'package:gastos_personales/presentation/screens/widgets/expense_initial_data.dart';

class ReceiptListPage extends StatelessWidget {
  const ReceiptListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReceiptScannerBloc(ReceiptRepositoryImpl()),
      child: const _ReceiptListView(),
    );
  }
}

class _ReceiptListView extends StatefulWidget {
  const _ReceiptListView();

  @override
  State<_ReceiptListView> createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<_ReceiptListView> {
  Future<void> _editReceipt(ReceiptScanResult receipt) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptEditPage(
          imagePath: receipt.imagePath,
          ocrText: receipt.ocrText,
          hintTotal: receipt.detectedTotal,
        ),
      ),
    );

    if (!mounted || result == null) return;

    context.read<ReceiptScannerBloc>().add(ReceiptUpdateTotalRequested(
      id: receipt.id,
      total: result['total'] as double,
    ));
  }

  String _formatDate(DateTime date) {
    final months = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<ReceiptScannerBloc, ReceiptScannerState>(
      builder: (context, state) {
        final receipts = state is ReceiptScannerLoaded ? state.receipts : <ReceiptScanResult>[];
        final totalSum = state is ReceiptScannerLoaded ? state.totalSum : 0.0;

        return Scaffold(
          appBar: AppBar(
            title: Text(loc.receiptListTitle),
            centerTitle: true,
            actions: [
              if (receipts.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: loc.clearList,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) {
                      final loc = AppLocalizations.of(ctx)!;
                      return AlertDialog(
                        title: Text(loc.clearListTitle),
                        content: Text(loc.clearListConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text(loc.cancel),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<ReceiptScannerBloc>().add(ReceiptClearAllRequested());
                            },
                            child: Text(loc.clear, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                          ),
                        ],
                      );
                    },
                    );
                  },
                ),
            ],
          ),
          body: Column(
            children: [
              if (receipts.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 80, color: cs.onSurfaceVariant.withValues(alpha: 0.4)),
                        const SizedBox(height: 16),
                        Text(
                          loc.noReceipts,
                          style: TextStyle(fontSize: 18, color: cs.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.noReceiptsHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: receipts.length,
                    itemBuilder: (context, index) {
                      final receipt = receipts[index];
                  return _ReceiptListItem(
                    receipt: receipt,
                    onTap: receipt.status == ReceiptStatus.needsReview ? () => _editReceipt(receipt) : null,
                    onDelete: () {
                      context.read<ReceiptScannerBloc>().add(ReceiptDeleteRequested(receipt.id));
                    },
                    onRegisterExpense: receipt.detectedTotal != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NewExpensePage(
                                  initialData: ExpenseInitialData(
                                    amount: receipt.detectedTotal!,
                                    description: loc.scannedReceipt,
                                  ),
                                ),
                              ),
                            );
                          }
                        : null,
                    formatDate: _formatDate,
                  );
                    },
                  ),
                ),

              // Total bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  border: Border(top: BorderSide(color: cs.outlineVariant, width: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.totalAccumulated,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimaryContainer,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      '\$ ${totalSum.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(builder: (_) => const ReceiptCapturePage()),
                        );
                        if (!mounted || result == null) return;
                        context.read<ReceiptScannerBloc>().add(ReceiptScanCompleted(
                          imagePath: result['imagePath'] as String,
                          ocrText: result['ocrText'] as String,
                          detectedTotal: result['total'] as double?,
                        ));
                      },
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(loc.scanButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReceiptListItem extends StatelessWidget {
  final ReceiptScanResult receipt;
  final VoidCallback? onTap;
  final VoidCallback onDelete;
  final VoidCallback? onRegisterExpense;
  final String Function(DateTime) formatDate;

  const _ReceiptListItem({
    required this.receipt,
    this.onTap,
    required this.onDelete,
    this.onRegisterExpense,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;

    final statusColor = switch (receipt.status) {
      ReceiptStatus.completed => cs.tertiary,
      ReceiptStatus.needsReview => Colors.orange,
      ReceiptStatus.processing => cs.primary,
      ReceiptStatus.error => cs.error,
    };

    final statusLabel = switch (receipt.status) {
      ReceiptStatus.completed => loc.statusCompleted,
      ReceiptStatus.needsReview => loc.statusNeedsReview,
      ReceiptStatus.processing => loc.statusProcessing,
      ReceiptStatus.error => loc.statusError,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: receipt.status == ReceiptStatus.needsReview ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 56,
                  height: 56,
                  child: Image.file(
                    File(receipt.imagePath),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceContainerLowest,
                      child: Icon(Icons.receipt_outlined, color: cs.onSurfaceVariant.withValues(alpha: 0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '\$ ${receipt.detectedTotal?.toStringAsFixed(2) ?? '—'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            statusLabel,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatDate(receipt.scanDate),
                      style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                    if (receipt.status == ReceiptStatus.needsReview)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          loc.tapToReview,
                          style: TextStyle(fontSize: 11, color: Colors.orange.shade700),
                        ),
                      ),
                    if (onRegisterExpense != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onRegisterExpense,
                            icon: const Icon(Icons.add_shopping_cart_outlined, size: 16),
                            label: Text(loc.registerExpense, style: const TextStyle(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Delete
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20, color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
