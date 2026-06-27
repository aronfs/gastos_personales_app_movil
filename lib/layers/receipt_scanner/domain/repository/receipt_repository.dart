import 'package:gastos_personales/layers/receipt_scanner/domain/entity/receipt_scan_result.dart';

abstract class ReceiptRepository {
  List<ReceiptScanResult> getReceipts();
  void addReceipt(ReceiptScanResult receipt);
  void updateReceipt(ReceiptScanResult receipt);
  void deleteReceipt(String id);
  void clearAll();
}
