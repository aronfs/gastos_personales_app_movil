import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/custom_text_style.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';

final _theme = MaterialTheme.lightScheme();
AppTextStyle get textStyleBase => AppTextStyle.textStyle();
AppTextStyle textStyleBlack = AppTextStyle.applyColor(textStyleBase, Colors.black);
AppTextStyle textStyleWhite = AppTextStyle.applyColor(textStyleBase, _theme.surface);
AppTextStyle textStyleGrey = AppTextStyle.applyColor(textStyleBase, Colors.grey);
