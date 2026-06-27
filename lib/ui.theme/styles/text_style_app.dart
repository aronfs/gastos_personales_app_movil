import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/custom_text_style.dart';

AppTextStyle get textStyleBase => AppTextStyle.textStyle();
AppTextStyle textStyleBlack(ColorScheme cs) =>
    AppTextStyle.applyColor(textStyleBase, cs.onSurface);
AppTextStyle textStyleWhite(ColorScheme cs) =>
    AppTextStyle.applyColor(textStyleBase, cs.onPrimary);
AppTextStyle textStyleGrey(ColorScheme cs) =>
    AppTextStyle.applyColor(textStyleBase, cs.onSurfaceVariant);
