import 'package:equatable/equatable.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';

abstract class ReceiptScannerEvent extends Equatable {
  const ReceiptScannerEvent();

  @override
  List<Object?> get props => [];
}

class ReceiptScanCompleted extends ReceiptScannerEvent {
  final String imagePath;
  final String ocrText;
  final double? detectedTotal;

  const ReceiptScanCompleted({
    required this.imagePath,
    required this.ocrText,
    this.detectedTotal,
  });

  @override
  List<Object?> get props => [imagePath, ocrText, detectedTotal];
}

class ReceiptDeleteRequested extends ReceiptScannerEvent {
  final String id;

  const ReceiptDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class ReceiptUpdateTotalRequested extends ReceiptScannerEvent {
  final String id;
  final double total;

  const ReceiptUpdateTotalRequested({required this.id, required this.total});

  @override
  List<Object?> get props => [id, total];
}

class ReceiptClearAllRequested extends ReceiptScannerEvent {}

class ReceiptScanAdded extends ReceiptScannerEvent {
  final ReceiptScanResult result;

  const ReceiptScanAdded(this.result);

  @override
  List<Object?> get props => [result];
}
