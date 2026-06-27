import 'package:equatable/equatable.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';

abstract class ReceiptScannerState extends Equatable {
  const ReceiptScannerState();

  @override
  List<Object?> get props => [];
}

class ReceiptScannerInitial extends ReceiptScannerState {}

class ReceiptScannerLoaded extends ReceiptScannerState {
  final List<ReceiptScanResult> receipts;
  final double totalSum;

  const ReceiptScannerLoaded({
    required this.receipts,
    required this.totalSum,
  });

  @override
  List<Object?> get props => [receipts, totalSum];
}
