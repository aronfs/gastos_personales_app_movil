import 'package:flutter/material.dart';

/// Grid de 8px — sistema de espaciado consistente
class Spacing {
  const Spacing._();

  static double get xs => 8;
  static double get sm => 16;
  static double get md => 24;
  static double get lg => 32;
  static double get xl => 48;
}

/// Border radius tokens
class RadiusTokens {
  const RadiusTokens._();

  static BorderRadius get sm => BorderRadius.circular(4);
  static BorderRadius get md => BorderRadius.circular(8);
  static BorderRadius get lg => BorderRadius.circular(12);
  static BorderRadius get xl => BorderRadius.circular(16);
  static BorderRadius get full => BorderRadius.circular(999);
}

/// Elevaciones según Material Design 3
class ElevationTokens {
  const ElevationTokens._();

  static List<BoxShadow> level0(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0),
          blurRadius: 0,
          offset: const Offset(0, 0),
        ),
      ];

  static List<BoxShadow> level1(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> level2(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}

/// Touch target mínimo de 44px (accesibilidad AA)
class TouchTarget {
  const TouchTarget._();

  static double get minSize => 44;
}
