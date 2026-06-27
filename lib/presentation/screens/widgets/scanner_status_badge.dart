import 'package:flutter/material.dart';

/// Badge de estado con punto de color pulsante y texto.
/// Usado para mostrar "● Detectando..." dentro del visor de escaneo.
class ScannerStatusBadge extends StatefulWidget {
  final String label;
  final Color dotColor;
  final bool animate;

  const ScannerStatusBadge({
    super.key,
    required this.label,
    this.dotColor = const Color(0xFF34C759),
    this.animate = true,
  });

  @override
  State<ScannerStatusBadge> createState() => _ScannerStatusBadgeState();
}

class _ScannerStatusBadgeState extends State<ScannerStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _opacity,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 7),
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
