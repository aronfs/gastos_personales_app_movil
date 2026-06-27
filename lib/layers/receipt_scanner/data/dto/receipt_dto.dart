import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';

class ReceiptDto {
  final String id;
  final String imagePath;
  final String ocrText;
  final double? detectedTotal;
  final String scanDate;
  final String status;

  const ReceiptDto({
    required this.id,
    required this.imagePath,
    required this.ocrText,
    this.detectedTotal,
    required this.scanDate,
    required this.status,
  });

  factory ReceiptDto.fromEntity(ReceiptScanResult entity) {
    return ReceiptDto(
      id: entity.id,
      imagePath: entity.imagePath,
      ocrText: entity.ocrText,
      detectedTotal: entity.detectedTotal,
      scanDate: entity.scanDate.toIso8601String(),
      status: entity.status.name,
    );
  }

  ReceiptScanResult toEntity() {
    return ReceiptScanResult(
      id: id,
      imagePath: imagePath,
      ocrText: ocrText,
      detectedTotal: detectedTotal,
      scanDate: DateTime.parse(scanDate),
      status: ReceiptStatus.values.firstWhere((s) => s.name == status),
    );
  }
}
