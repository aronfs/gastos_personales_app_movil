import 'package:gastos_personales/layers/scanner/domain/entity/product_scan_result.dart';

class AnalyzeShelfLabelUseCase {
  /// Analiza el texto extraído por OCR y devuelve un ProductScanResult si parece ser una cenefa válida
  ProductScanResult? call(String text, String imagePath) {
    if (text.isEmpty) return null;

    // 1. Extraer precio
    // Buscamos algo parecido a $1.30 o 1,30.
    final priceRegex = RegExp(r'\$?\s*(\d+[,.]\d{2})');
    final priceMatch = priceRegex.firstMatch(text);

    if (priceMatch == null) {
      return null; // Si no hay precio, probablemente no sea una cenefa
    }

    // Convertir el texto capturado a double
    final priceStr = priceMatch.group(1)!.replaceAll(',', '.');
    final price = double.tryParse(priceStr) ?? 0.0;

    // 2. Extraer nombre y presentación
    // Asumimos que todo el texto antes o después del precio (o la línea más larga) es el nombre
    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    
    String name = 'Producto Desconocido';
    String presentation = '';

    for (final line in lines) {
      if (!priceRegex.hasMatch(line) && line.length > 3) {
        // Encontramos una línea que no es solo el precio y tiene texto
        name = line;
        break;
      }
    }

    // Heurística simple para presentación (ej: 330 ML, 1 KG)
    final presentationRegex = RegExp(r'(\d+\s*(ML|L|G|KG|OZ|CC))', caseSensitive: false);
    final presentationMatch = presentationRegex.firstMatch(text);
    if (presentationMatch != null) {
      presentation = presentationMatch.group(1)!;
    }

    return ProductScanResult(
      name: name,
      presentation: presentation,
      price: price,
      imagePath: imagePath,
    );
  }
}
