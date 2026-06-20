import 'package:equatable/equatable.dart';
import 'package:gastos_personales/layers/scanner/domain/entity/product_scan_result.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object?> get props => [];
}

class ScannerInitial extends ScannerState {}

class ScannerCameraLoading extends ScannerState {}

class ScannerScanning extends ScannerState {}

class ScannerProductDetected extends ScannerState {
  final ProductScanResult result;

  const ScannerProductDetected(this.result);

  @override
  List<Object?> get props => [result];
}

class ScannerError extends ScannerState {
  final String message;

  const ScannerError(this.message);

  @override
  List<Object?> get props => [message];
}
