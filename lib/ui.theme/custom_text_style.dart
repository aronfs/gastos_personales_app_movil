import 'package:flutter/material.dart';

class AppTextStyle {
  
  TextStyle display32;
  TextStyle h124;
  TextStyle h220;
  TextStyle body14;
  TextStyle caption12;

  AppTextStyle({
    required this.display32,
    required this.h124,
    required this.h220,
    required this.body14,
    required this.caption12,
  });

  factory AppTextStyle.applyColor(
    AppTextStyle appTextStyle,
    Color color,
  ) {
    return AppTextStyle(
      display32: appTextStyle.display32.copyWith(color: color),
      h124: appTextStyle.h124.copyWith(color: color),
      h220: appTextStyle.h220.copyWith(color: color),
      body14: appTextStyle.body14.copyWith(color: color),
      caption12: appTextStyle.caption12.copyWith(color: color),
    );
  }

  factory AppTextStyle.textStyle() {
    return AppTextStyle(
      display32: _styleInterBold.copyWith(fontSize: 32),
      h124: _styleInterBold.copyWith(fontSize: 24),
      h220: _styleInterSemiBold.copyWith(fontSize: 20),
      body14: _styleInterRegular.copyWith(fontSize: 14),
      caption12: _styleInterMedium.copyWith(fontSize: 12),
    );
  }

  static TextStyle get _styleInterBold => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      );

  static TextStyle get _styleInterSemiBold => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
      );

  static TextStyle get _styleInterMedium => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      );

  static TextStyle get _styleInterRegular => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      );
}