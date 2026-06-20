

import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/size_app.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';
import 'package:gastos_personales/ui.theme/styles/text_style_app.dart';

final theme = MaterialTheme.lightScheme();


ButtonStyle get blueButtonStyle => ElevatedButton.styleFrom(
  backgroundColor: theme.primary,
  foregroundColor: theme.onPrimary,
  textStyle: textStyleBase.h220,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.circular(sizeRadiusButton),
  ),
);