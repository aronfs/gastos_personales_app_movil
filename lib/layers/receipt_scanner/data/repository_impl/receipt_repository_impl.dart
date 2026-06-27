import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';
import 'package:gastos_personales/layers/receipt_scanner/domain/repository/receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final List<ReceiptScanResult> _receipts = [];

  @override
  List<ReceiptScanResult> getReceipts() => List.unmodifiable(_receipts);

  @override
  void addReceipt(ReceiptScanResult receipt) {
    _receipts.add(receipt);
  }

  @override
  void updateReceipt(ReceiptScanResult receipt) {
    final index = _receipts.indexWhere((r) => r.id == receipt.id);
    if (index != -1) {
      _receipts[index] = receipt;
    }
  }

  @override
  void deleteReceipt(String id) {
    _receipts.removeWhere((r) => r.id == id);
  }

  @override
  void clearAll() {
    _receipts.clear();
  }
}
