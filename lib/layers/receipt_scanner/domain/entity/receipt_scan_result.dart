import 'package:equatable/equatable.dart';

enum ReceiptStatus { processing, completed, needsReview, error }

class ReceiptScanResult extends Equatable {
  final String id;
  final String imagePath;
  final String ocrText;
  final double? detectedTotal;
  final DateTime scanDate;
  final ReceiptStatus status;

  const ReceiptScanResult({
    required this.id,
    required this.imagePath,
    required this.ocrText,
    this.detectedTotal,
    required this.scanDate,
    required this.status,
  });

  ReceiptScanResult copyWith({
    String? id,
    String? imagePath,
    String? ocrText,
    double? detectedTotal,
    DateTime? scanDate,
    ReceiptStatus? status,
  }) {
    return ReceiptScanResult(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      ocrText: ocrText ?? this.ocrText,
      detectedTotal: detectedTotal ?? this.detectedTotal,
      scanDate: scanDate ?? this.scanDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, imagePath, ocrText, detectedTotal, scanDate, status];
}
