import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/size_app.dart';
import 'package:gastos_personales/ui.theme/styles/button_style_app.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';

final theme = MaterialTheme.lightScheme();

class AppThemeData {
  static get themeSplash => ThemeData(
    useMaterial3: true,
    colorScheme: theme,
    scaffoldBackgroundColor: theme.primary,
    appBarTheme: AppBarTheme(backgroundColor: theme.primary),
  );

  static OutlineInputBorder get borderText => OutlineInputBorder(
    borderRadius: BorderRadius.circular(sizeRadiusTextField),
    borderSide: BorderSide(color: Colors.grey),
  );

  static get themeForms => ThemeData(
    useMaterial3: true,
    colorScheme: theme,
    scaffoldBackgroundColor: theme.surface,
    appBarTheme: AppBarTheme(backgroundColor: theme.onPrimary),

    elevatedButtonTheme: ElevatedButtonThemeData(style: blueButtonStyle),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      filled: true,
      fillColor: theme.onPrimary,
      hintStyle: TextStyle(color: Colors.grey),
      enabledBorder: borderText,
      focusedBorder: borderText,
      disabledBorder: borderText,
    ),
  );

  static get themeHome => ThemeData(
    useMaterial3: true,
    colorScheme: theme,
    scaffoldBackgroundColor: theme.surface,
    appBarTheme: AppBarTheme(backgroundColor: theme.onPrimary),
  );

  static get themeMovs => ThemeData(
    useMaterial3: true,
    colorScheme: theme,
    scaffoldBackgroundColor: theme.surface,
    appBarTheme: AppBarTheme(backgroundColor: theme.onPrimary),
  );
}
