import 'package:flutter/material.dart';
import 'package:gastos_personales/ui.theme/custom_text_style.dart';
import 'package:gastos_personales/ui.theme/design_tokens.dart';
import 'package:gastos_personales/ui.theme/styles/color_scheme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(MaterialTheme.lightScheme());
  static ThemeData get dark => _build(MaterialTheme.darkScheme());

  static ThemeData _build(ColorScheme cs) {
    final textTheme = AppTextStyle.toMaterialTextTheme();
    final isLight = cs.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: cs.brightness,
      colorScheme: cs,
      scaffoldBackgroundColor: isLight ? const Color(0xFFF8FAFC) : cs.surface,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.headlineMedium?.copyWith(
          color: cs.onSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          textStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          minimumSize: Size(double.infinity, TouchTarget.minSize),
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.lg,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          minimumSize: Size(double.infinity, TouchTarget.minSize),
          side: BorderSide(color: cs.outline),
          shape: RoundedRectangleBorder(
            borderRadius: RadiusTokens.lg,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          minimumSize: Size(0, TouchTarget.minSize),
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xs,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? cs.surfaceContainerLowest : cs.surfaceContainerHigh,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: RadiusTokens.lg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.lg,
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.lg,
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.lg,
          borderSide: BorderSide(color: cs.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: RadiusTokens.lg,
          borderSide: BorderSide(color: cs.error, width: 2),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant,
        ),
        prefixIconColor: cs.onSurfaceVariant,
        suffixIconColor: cs.onSurfaceVariant,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 2,
        shape: const CircleBorder(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainerLowest,
        selectedColor: cs.primary,
        labelStyle: textTheme.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.sm,
          vertical: Spacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.full,
        ),
      ),
      cardTheme: CardThemeData(
        color: cs.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: RadiusTokens.xl,
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cs.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: cs.inverseSurface == const Color(0xFF0F172A)
              ? Colors.white
              : Colors.black,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.lg),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: RadiusTokens.xl),
        titleTextStyle: textTheme.headlineMedium?.copyWith(color: cs.onSurface),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: cs.primary,
        linearTrackColor: cs.primaryContainer,
      ),
    );
  }
}
