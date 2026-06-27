import 'package:flutter/material.dart';
import 'scanner_corners_painter.dart';
import 'scanner_status_badge.dart';

/// Visor de escaneo de código de barras: fondo oscuro, esquinas azules
/// tipo cámara, simulación de barras con línea de escaneo animada,
/// badge de estado y tooltip inferior.
class BarcodeScannerViewer extends StatefulWidget {
  final String statusLabel;
  final String tooltipText;
  final bool isScanning;

  const BarcodeScannerViewer({
    super.key,
    this.statusLabel = 'Detectando...',
    this.tooltipText = 'Alinea la cenefa dentro del marco',
    this.isScanning = true,
  });

  @override
  State<BarcodeScannerViewer> createState() => _BarcodeScannerViewerState();
}

class _BarcodeScannerViewerState extends State<BarcodeScannerViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _lineController;
  late Animation<double> _linePosition;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _linePosition = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _lineController, curve: Curves.easeInOut),
    );
    if (widget.isScanning) {
      _lineController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF111527),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Simulación de código de barras (líneas verticales)
          Positioned.fill(
            child: CustomPaint(painter: _BarcodeSimPainter()),
          ),

          // Línea de escaneo animada
          AnimatedBuilder(
            animation: _linePosition,
            builder: (context, _) {
              return Positioned(
                top: 220 * _linePosition.value - 1,
                left: 24,
                right: 24,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF2F6BFF).withValues(alpha: 0.8),
                        const Color(0xFF2F6BFF),
                        const Color(0xFF2F6BFF).withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Esquinas azules tipo visor
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CustomPaint(
                painter: ScannerCornersPainter(
                  color: const Color(0xFF2F6BFF),
                  cornerLength: 24,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

          // Badge de estado "Detectando..."
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Center(
              child: ScannerStatusBadge(label: widget.statusLabel),
            ),
          ),

          // Tooltip inferior
          Positioned(
            bottom: 14,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2235).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                widget.tooltipText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simula el fondo de un código de barras con líneas verticales de
/// distintos anchos y opacidades.
class _BarcodeSimPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Patrón de barras de ancho variable
    final List<double> widths = [
      3, 6, 2, 8, 3, 12, 4, 6, 2, 10, 3, 5, 8, 3, 6, 2, 4, 8, 5, 3,
      10, 2, 6, 4, 8, 3, 5, 2, 7, 4, 6, 3, 9, 2, 5, 3, 6, 8, 2, 4,
    ];

    double x = size.width * 0.12;
    bool dark = true;
    for (final w in widths) {
          paint.color = dark
          ? Colors.white.withValues(alpha: 0.18)
          : Colors.transparent;
      canvas.drawRect(Rect.fromLTWH(x, size.height * 0.18, w, size.height * 0.64), paint);
      x += w + 1;
      dark = !dark;
      if (x > size.width * 0.88) break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
