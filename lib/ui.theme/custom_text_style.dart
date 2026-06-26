import 'package:flutter/material.dart';

class AppTextStyle {
  final TextStyle display32;
  final TextStyle h124;
  final TextStyle h220;
  final TextStyle body14;
  final TextStyle caption12;

  const AppTextStyle({
    required this.display32,
    required this.h124,
    required this.h220,
    required this.body14,
    required this.caption12,
  });

  factory AppTextStyle.applyColor(AppTextStyle base, Color color) {
    return AppTextStyle(
      display32: base.display32.copyWith(color: color),
      h124: base.h124.copyWith(color: color),
      h220: base.h220.copyWith(color: color),
      body14: base.body14.copyWith(color: color),
      caption12: base.caption12.copyWith(color: color),
    );
  }

  factory AppTextStyle.textStyle() {
    return AppTextStyle(
      display32: _interBold.copyWith(fontSize: 32, height: 1.2),
      h124: _interBold.copyWith(fontSize: 24, height: 1.3),
      h220: _interSemiBold.copyWith(fontSize: 20, height: 1.3),
      body14: _interRegular.copyWith(fontSize: 14, height: 1.5),
      caption12: _interMedium.copyWith(fontSize: 12, height: 1.4),
    );
  }

  static const TextStyle _interBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _interSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _interMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _interRegular = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );

  static TextTheme toMaterialTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 32,
        height: 1.2,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 24,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }
}
