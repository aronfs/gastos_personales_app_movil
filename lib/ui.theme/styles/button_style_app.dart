import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/custom_text_style.dart';
import 'package:gastos_personales/ui.theme/design_tokens.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';

final _theme = MaterialTheme.lightScheme();

ButtonStyle get blueButtonStyle => ElevatedButton.styleFrom(
  backgroundColor: _theme.primary,
  foregroundColor: _theme.onPrimary,
  textStyle: AppTextStyle.textStyle().h220,
  minimumSize: Size(double.infinity, TouchTarget.minSize),
  padding: EdgeInsets.symmetric(
    horizontal: Spacing.md,
    vertical: Spacing.sm,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: RadiusTokens.lg,
  ),
);
