import 'package:flutter/material.dart';

class ProfileThemeToggle extends StatefulWidget {
  final ColorScheme cs;

  const ProfileThemeToggle({super.key, required this.cs});

  @override
  State<ProfileThemeToggle> createState() => _ProfileThemeToggleState();
}

class _ProfileThemeToggleState extends State<ProfileThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void didUpdateWidget(covariant ProfileThemeToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cs.brightness != widget.cs.brightness) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.cs.brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, _) {
        return Transform.rotate(
          angle: _rotation.value * 3.14159,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 44,
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
            ),
            child: Align(
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFF59E0B),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark
                              ? const Color(0xFF6366F1)
                              : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
