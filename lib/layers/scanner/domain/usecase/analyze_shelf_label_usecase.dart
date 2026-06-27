import 'dart:ui';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:gastos_personales/layers/scanner/domain/entity/product_scan_result.dart';

enum ShelfLabelStatus { success, warning, error }

class AnalyzeShelfLabelResult {
  final ShelfLabelStatus status;
  final String? message;
  final ProductScanResult? product;

  AnalyzeShelfLabelResult.success(this.product) : status = ShelfLabelStatus.success, message = null;
  AnalyzeShelfLabelResult.warning(this.message) : status = ShelfLabelStatus.warning, product = null;
  AnalyzeShelfLabelResult.error(this.message) : status = ShelfLabelStatus.error, product = null;
}

class AnalyzeShelfLabelUseCase {
  /// Analiza el texto extraído por OCR, filtrando bloques que caen fuera de [roi]
  AnalyzeShelfLabelResult call(RecognizedText recognizedText, Rect roi, String imagePath) {
    if (recognizedText.blocks.isEmpty) {
      return AnalyzeShelfLabelResult.error("No se detectó texto");
    }

    final List<TextBlock> validBlocks = [];
    final priceRegex = RegExp(r'\$?\s*(\d+[,.]\d{2})');

    for (final block in recognizedText.blocks) {
      final blockRect = block.boundingBox;
      
      // Calcular qué porcentaje del bloque está dentro del ROI
      final intersection = roi.intersect(blockRect);
      
      if (intersection.width > 0 && intersection.height > 0) {
        final intersectionArea = intersection.width * intersection.height;
        final blockArea = blockRect.width * blockRect.height;
        final coverage = intersectionArea / blockArea;

        // Caso 5.1: Si menos del 70% de la etiqueta está dentro del rectángulo
        // Nota: Evaluamos por bloque. Si un bloque crucial está demasiado cortado, podríamos avisar.
        if (coverage > 0.70) {
          validBlocks.add(block);
        } else {
          // Si es un bloque muy grande (probablemente la cenefa entera) y está recortado:
          return AnalyzeShelfLabelResult.warning("Acerque la etiqueta al área de escaneo");
        }
      }
    }

    if (validBlocks.isEmpty) {
      return AnalyzeShelfLabelResult.error("No se detectó texto en el área central");
    }

    // Identificar todos los precios (Caso 5.2)
    final List<_PriceCandidate> priceCandidates = [];
    
    for (final block in validBlocks) {
      for (final line in block.lines) {
        final match = priceRegex.firstMatch(line.text);
        if (match != null) {
          final priceStr = match.group(1)!.replaceAll(',', '.');
          final price = double.tryParse(priceStr);
          if (price != null) {
            priceCandidates.add(_PriceCandidate(price: price, rect: line.boundingBox));
          }
        }
      }
    }

    // Caso 5.3: Si no existe precio detectable
    if (priceCandidates.isEmpty) {
      return AnalyzeShelfLabelResult.warning("No se pudo identificar el precio.\nIntente nuevamente.");
    }

    // Caso 5.2: Si hay múltiples precios, elegir el más grande visualmente
    _PriceCandidate? bestPrice;
    if (priceCandidates.length > 1) {
      priceCandidates.sort((a, b) => b.rect.height.compareTo(a.rect.height));
      bestPrice = priceCandidates.first;
    } else {
      bestPrice = priceCandidates.first;
    }

    // Extraer nombre y presentación
    String name = 'Producto Desconocido';
    String presentation = '';

    // Encontrar el texto más cercano al precio o el más grande para el nombre
    // Excluyendo el bloque que tiene el precio.
    final presentationRegex = RegExp(r'(\d+\s*(ML|L|G|KG|OZ|CC))', caseSensitive: false);

    for (final block in validBlocks) {
      for (final line in block.lines) {
        if (!priceRegex.hasMatch(line.text)) {
          // Si tiene formato de presentación
          final presMatch = presentationRegex.firstMatch(line.text);
          if (presMatch != null) {
            presentation = presMatch.group(1)!;
            // Remover la presentación del nombre si están en la misma línea
            String possibleName = line.text.replaceAll(presMatch.group(0)!, '').trim();
            if (possibleName.isNotEmpty && possibleName.length > 3) {
              name = possibleName;
            }
          } else if (line.text.length > 3 && name == 'Producto Desconocido') {
            // Asumimos que el primer texto razonable es el nombre
            name = line.text;
          }
        }
      }
    }

    return AnalyzeShelfLabelResult.success(
      ProductScanResult(
        name: name,
        presentation: presentation,
        price: bestPrice.price,
        imagePath: imagePath,
      )
    );
  }
}

class _PriceCandidate {
  final double price;
  final Rect rect;
  _PriceCandidate({required this.price, required this.rect});
}
