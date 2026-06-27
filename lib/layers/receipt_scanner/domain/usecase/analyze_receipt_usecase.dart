class AnalyzeReceiptResult {
  final double? total;
  final bool needsReview;
  final String? message;

  const AnalyzeReceiptResult({this.total, this.needsReview = false, this.message});
}

class AnalyzeReceiptUseCase {
  static const _keywords = [
    'TOTAL A PAGAR',
    'VALOR TOTAL',
    'TOTAL GENERAL',
    'IMPORTE TOTAL',
    'TOTAL NETO',
    'A PAGAR',
    'TOTAL USD',
    'TOTAL \$',
    'TOTAL PAGAR',
    'SUBTOTAL',
    'IMPORTE',
    'MONTO TOTAL',
    'MONTO',
    'NETO',
    'TOTAL',
  ];

  AnalyzeReceiptResult call(String ocrText) {
    if (ocrText.trim().isEmpty) {
      return const AnalyzeReceiptResult(
        needsReview: true,
        message: 'No se detectó texto en la factura',
      );
    }

    final lines = ocrText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final exactPriceRegex = RegExp(r'(\d+[.,]\d{2})');

    // Recolectar candidatos: (keyword, price, lineIndex)
    final List<_Candidate> candidates = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].toUpperCase();

      for (final keyword in _keywords) {
        if (!line.contains(keyword)) continue;

        // Buscar precio en esta línea
        double? price = _extractPrice(lines[i], exactPriceRegex);

        // Si no hay precio, buscar en la siguiente línea
        if (price == null && i + 1 < lines.length) {
          price = _extractPrice(lines[i + 1], exactPriceRegex);
        }

        if (price != null) {
          candidates.add(_Candidate(
            keyword: keyword,
            price: price,
            lineIndex: i,
            isExactTotal: keyword == 'TOTAL' || keyword == 'TOTAL A PAGAR' || keyword == 'VALOR TOTAL',
          ));
        }
      }
    }

    if (candidates.isEmpty) {
      // Fallback: tomar el último precio con .XX del texto
      final matches = exactPriceRegex.allMatches(ocrText).toList();
      if (matches.isNotEmpty) {
        final lastMatch = matches.last;
        final price = double.tryParse(lastMatch.group(1)!.replaceAll(',', '.'));
        if (price != null) {
          return AnalyzeReceiptResult(
            total: price,
            needsReview: true,
            message: 'Total detectado tentativamente, verifique el valor',
          );
        }
      }
      return const AnalyzeReceiptResult(
        needsReview: true,
        message: 'No se pudo detectar el total automáticamente',
      );
    }

    // Estrategia: priorizar por tipo de keyword, luego por último en la factura
    candidates.sort((a, b) {
      // Exact total keywords first
      if (a.isExactTotal && !b.isExactTotal) return -1;
      if (!a.isExactTotal && b.isExactTotal) return 1;
      // Then by recency (last in document is more likely the total)
      return b.lineIndex.compareTo(a.lineIndex);
    });

    final best = candidates.first;
    return AnalyzeReceiptResult(total: best.price);
  }

  double? _extractPrice(String line, RegExp regex) {
    final match = regex.firstMatch(line);
    if (match == null) return null;
    final raw = match.group(1)!;

    String normalized;
    if (raw.contains(',') && !raw.contains('.')) {
      normalized = raw.replaceAll(',', '.');
    } else if (raw.contains(',') && raw.contains('.')) {
      // Formato: 1,234.56 o 1.234,56
      if (raw.lastIndexOf('.') > raw.lastIndexOf(',')) {
        normalized = raw.replaceAll(',', '');
      } else {
        normalized = raw.replaceAll('.', '').replaceAll(',', '.');
      }
    } else {
      normalized = raw;
    }

    return double.tryParse(normalized);
  }
}

class _Candidate {
  final String keyword;
  final double price;
  final int lineIndex;
  final bool isExactTotal;

  const _Candidate({
    required this.keyword,
    required this.price,
    required this.lineIndex,
    required this.isExactTotal,
  });
}
