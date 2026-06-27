import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/repository/receipt_repository.dart';
import 'package:gastos_personales/presentation/screens/bloc/receipt_scanner/receipt_scanner_event.dart';
import 'package:gastos_personales/presentation/screens/bloc/receipt_scanner/receipt_scanner_state.dart';

class ReceiptScannerBloc extends Bloc<ReceiptScannerEvent, ReceiptScannerState> {
  final ReceiptRepository _repository;

  ReceiptScannerBloc(this._repository) : super(ReceiptScannerInitial()) {
    on<ReceiptScanCompleted>(_onScanCompleted);
    on<ReceiptScanAdded>(_onScanAdded);
    on<ReceiptDeleteRequested>(_onDeleteRequested);
    on<ReceiptUpdateTotalRequested>(_onUpdateTotal);
    on<ReceiptClearAllRequested>(_onClearAll);
  }

  double _calculateTotal(List<ReceiptScanResult> receipts) {
    double sum = 0;
    for (final r in receipts) {
      if (r.detectedTotal != null) {
        sum += r.detectedTotal!;
      }
    }
    return sum;
  }

  void _emitLoaded(Emitter<ReceiptScannerState> emit) {
    final receipts = _repository.getReceipts();
    emit(ReceiptScannerLoaded(receipts: receipts, totalSum: _calculateTotal(receipts)));
  }

  Future<void> _onScanCompleted(ReceiptScanCompleted event, Emitter<ReceiptScannerState> emit) async {
    final status = event.detectedTotal != null ? ReceiptStatus.completed : ReceiptStatus.needsReview;
    final receipt = ReceiptScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: event.imagePath,
      ocrText: event.ocrText,
      detectedTotal: event.detectedTotal,
      scanDate: DateTime.now(),
      status: status,
    );
    _repository.addReceipt(receipt);
    _emitLoaded(emit);
  }

  Future<void> _onScanAdded(ReceiptScanAdded event, Emitter<ReceiptScannerState> emit) async {
    _repository.addReceipt(event.result);
    _emitLoaded(emit);
  }

  Future<void> _onDeleteRequested(ReceiptDeleteRequested event, Emitter<ReceiptScannerState> emit) async {
    _repository.deleteReceipt(event.id);
    _emitLoaded(emit);
  }

  Future<void> _onUpdateTotal(ReceiptUpdateTotalRequested event, Emitter<ReceiptScannerState> emit) async {
    final receipts = _repository.getReceipts();
    final index = receipts.indexWhere((r) => r.id == event.id);
    if (index != -1) {
      final updated = receipts[index].copyWith(
        detectedTotal: event.total,
        status: ReceiptStatus.completed,
      );
      _repository.updateReceipt(updated);
    }
    _emitLoaded(emit);
  }

  Future<void> _onClearAll(ReceiptClearAllRequested event, Emitter<ReceiptScannerState> emit) async {
    _repository.clearAll();
    emit(const ReceiptScannerLoaded(receipts: [], totalSum: 0));
  }
}
