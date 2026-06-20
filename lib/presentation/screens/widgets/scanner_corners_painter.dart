import 'package:flutter/material.dart';

/// Dibuja las 4 esquinas tipo "visor de cámara" de color azul sobre
/// el contenedor del scanner.
class ScannerCornersPainter extends CustomPainter {
  final Color color;
  final double cornerLength;
  final double strokeWidth;
  final double radius;

  const ScannerCornersPainter({
    this.color = const Color(0xFF2F6BFF),
    this.cornerLength = 28,
    this.strokeWidth = 3,
    this.radius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double r = radius;
    final double cl = cornerLength;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(0, r + cl)
        ..lineTo(0, r)
        ..arcToPoint(Offset(r, 0),
            radius: Radius.circular(r), clockwise: true)
        ..lineTo(r + cl, 0),
      paint,
    );

    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - r - cl, 0)
        ..lineTo(size.width - r, 0)
        ..arcToPoint(Offset(size.width, r),
            radius: Radius.circular(r), clockwise: true)
        ..lineTo(size.width, r + cl),
      paint,
    );

    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - r - cl)
        ..lineTo(0, size.height - r)
        ..arcToPoint(Offset(r, size.height),
            radius: Radius.circular(r), clockwise: false)
        ..lineTo(r + cl, size.height),
      paint,
    );

    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(size.width - r - cl, size.height)
        ..lineTo(size.width - r, size.height)
        ..arcToPoint(Offset(size.width, size.height - r),
            radius: Radius.circular(r), clockwise: false)
        ..lineTo(size.width, size.height - r - cl),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerCornersPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.strokeWidth != strokeWidth;
}
