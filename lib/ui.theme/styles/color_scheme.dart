import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

 static ColorScheme lightScheme() {
  return const ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E3A8A),

    secondary: Color(0xFF14B8A6),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFCCFBF1),
    onSecondaryContainer: Color(0xFF134E4A),

    tertiary: Color(0xFF22C55E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFDCFCE7),
    onTertiaryContainer: Color(0xFF14532D),

    error: Color(0xFFEF4444),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),

    surface: Color(0xFFF8FAFC),
    onSurface: Color(0xFF0F172A),

    surfaceTint: Color(0xFF2563EB),

    outline: Color(0xFFCBD5E1),
    outlineVariant: Color(0xFFE2E8F0),

    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    inverseSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF475569),
    inversePrimary: Color(0xFF93C5FD),

    primaryFixed: Color(0xFFDBEAFE),
    onPrimaryFixed: Color(0xFF1E3A8A),
    primaryFixedDim: Color(0xFF93C5FD),
    onPrimaryFixedVariant: Color(0xFF1D4ED8),

    secondaryFixed: Color(0xFFCCFBF1),
    onSecondaryFixed: Color(0xFF134E4A),
    secondaryFixedDim: Color(0xFF99F6E4),
    onSecondaryFixedVariant: Color(0xFF0F766E),

    tertiaryFixed: Color(0xFFDCFCE7),
    onTertiaryFixed: Color(0xFF14532D),
    tertiaryFixedDim: Color(0xFF86EFAC),
    onTertiaryFixedVariant: Color(0xFF15803D),

    surfaceDim: Color(0xFFE2E8F0),
    surfaceBright: Color(0xFFFFFFFF),

    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF8FAFC),
    surfaceContainer: Color(0xFFF1F5F9),
    surfaceContainerHigh: Color(0xFFE2E8F0),
    surfaceContainerHighest: Color(0xFFCBD5E1),
  );
}
  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff213367),
      surfaceTint: Color(0xff4b5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff596ba2),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003e37),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1e7a6e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff213367),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff596ba2),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafd),
      onSurface: Color(0xff0d1214),
      onSurfaceVariant: Color(0xff2f3839),
      outline: Color(0xff4b5456),
      outlineVariant: Color(0xff656f70),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xffb4c5ff),
      primaryFixed: Color(0xff596ba2),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff415388),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1e7a6e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff006056),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff596ba2),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff415388),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc2c7ca),
      surfaceBright: Color(0xfff5fafd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f4f7),
      surfaceContainer: Color(0xffe4e9ec),
      surfaceContainerHigh: Color(0xffd9dde1),
      surfaceContainerHighest: Color(0xffcdd2d5),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff15295c),
      surfaceTint: Color(0xff4b5c92),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff35477b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00332d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff00534a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff15295c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff35477b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fafd),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff252e2f),
      outlineVariant: Color(0xff414b4c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2c3134),
      inversePrimary: Color(0xffb4c5ff),
      primaryFixed: Color(0xff35477b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff1d3063),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff00534a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003a33),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff35477b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1d3063),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4b9bc),
      surfaceBright: Color(0xfff5fafd),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffedf1f4),
      surfaceContainer: Color(0xffdee3e6),
      surfaceContainerHigh: Color(0xffd0d5d8),
      surfaceContainerHighest: Color(0xffc2c7ca),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb4c5ff),
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff1a2d60),
      primaryContainer: Color(0xff324478),
      onPrimaryContainer: Color(0xffdbe1ff),
      secondary: Color(0xff82d5c7),
      onSecondary: Color(0xff003731),
      secondaryContainer: Color(0xff005048),
      onSecondaryContainer: Color(0xff9ef2e3),
      tertiary: Color(0xffb4c5ff),
      onTertiary: Color(0xff1a2d60),
      tertiaryContainer: Color(0xff324478),
      onTertiaryContainer: Color(0xffdbe1ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0f1416),
      onSurface: Color(0xffdee3e6),
      onSurfaceVariant: Color(0xffbfc8ca),
      outline: Color(0xff899294),
      outlineVariant: Color(0xff3f484a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e6),
      inversePrimary: Color(0xff4b5c92),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff00174b),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff324478),
      secondaryFixed: Color(0xff9ef2e3),
      onSecondaryFixed: Color(0xff00201c),
      secondaryFixedDim: Color(0xff82d5c7),
      onSecondaryFixedVariant: Color(0xff005048),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff00174b),
      tertiaryFixedDim: Color(0xffb4c5ff),
      onTertiaryFixedVariant: Color(0xff324478),
      surfaceDim: Color(0xff0f1416),
      surfaceBright: Color(0xff353a3d),
      surfaceContainerLowest: Color(0xff0a0f11),
      surfaceContainerLow: Color(0xff171c1f),
      surfaceContainer: Color(0xff1b2023),
      surfaceContainerHigh: Color(0xff252b2d),
      surfaceContainerHighest: Color(0xff303638),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd2dbff),
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff0d2255),
      primaryContainer: Color(0xff7d8fc8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff98ecdd),
      onSecondary: Color(0xff002b26),
      secondaryContainer: Color(0xff4a9e92),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffd2dbff),
      onTertiary: Color(0xff0d2255),
      tertiaryContainer: Color(0xff7d8fc8),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0f1416),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dee0),
      outline: Color(0xffaab4b5),
      outlineVariant: Color(0xff889294),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e6),
      inversePrimary: Color(0xff34467a),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff000e35),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff213367),
      secondaryFixed: Color(0xff9ef2e3),
      onSecondaryFixed: Color(0xff001511),
      secondaryFixedDim: Color(0xff82d5c7),
      onSecondaryFixedVariant: Color(0xff003e37),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff000e35),
      tertiaryFixedDim: Color(0xffb4c5ff),
      onTertiaryFixedVariant: Color(0xff213367),
      surfaceDim: Color(0xff0f1416),
      surfaceBright: Color(0xff404548),
      surfaceContainerLowest: Color(0xff04080a),
      surfaceContainerLow: Color(0xff191e21),
      surfaceContainer: Color(0xff23292b),
      surfaceContainerHigh: Color(0xff2e3336),
      surfaceContainerHighest: Color(0xff393e41),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffedefff),
      surfaceTint: Color(0xffb4c5ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffafc1fd),
      onPrimaryContainer: Color(0xff000928),
      secondary: Color(0xffaffff1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff7ed1c3),
      onSecondaryContainer: Color(0xff000e0b),
      tertiary: Color(0xffedefff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffafc1fd),
      onTertiaryContainer: Color(0xff000928),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0f1416),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f3),
      outlineVariant: Color(0xffbbc4c6),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e6),
      inversePrimary: Color(0xff34467a),
      primaryFixed: Color(0xffdbe1ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffb4c5ff),
      onPrimaryFixedVariant: Color(0xff000e35),
      secondaryFixed: Color(0xff9ef2e3),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff82d5c7),
      onSecondaryFixedVariant: Color(0xff001511),
      tertiaryFixed: Color(0xffdbe1ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb4c5ff),
      onTertiaryFixedVariant: Color(0xff000e35),
      surfaceDim: Color(0xff0f1416),
      surfaceBright: Color(0xff4b5154),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1b2023),
      surfaceContainer: Color(0xff2c3134),
      surfaceContainerHigh: Color(0xff373c3f),
      surfaceContainerHighest: Color(0xff42484a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  /// Warning
  static const warning = ExtendedColor(
    seed: Color(0xfff59e0b),
    value: Color(0xfff59e0b),
    light: ColorFamily(
      color: Color(0xff825513),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb8),
      onColorContainer: Color(0xff653e00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff825513),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb8),
      onColorContainer: Color(0xff653e00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff825513),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb8),
      onColorContainer: Color(0xff653e00),
    ),
    dark: ColorFamily(
      color: Color(0xfff8bb71),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xff653e00),
      onColorContainer: Color(0xffffddb8),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xfff8bb71),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xff653e00),
      onColorContainer: Color(0xffffddb8),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xfff8bb71),
      onColor: Color(0xff472a00),
      colorContainer: Color(0xff653e00),
      onColorContainer: Color(0xffffddb8),
    ),
  );

  /// Succes
  static const succes = ExtendedColor(
    seed: Color(0xff22c55e),
    value: Color(0xff22c55e),
    light: ColorFamily(
      color: Color(0xff35693f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffb6f1bb),
      onColorContainer: Color(0xff1b5129),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff35693f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffb6f1bb),
      onColorContainer: Color(0xff1b5129),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff35693f),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffb6f1bb),
      onColorContainer: Color(0xff1b5129),
    ),
    dark: ColorFamily(
      color: Color(0xff9bd4a0),
      onColor: Color(0xff003915),
      colorContainer: Color(0xff1b5129),
      onColorContainer: Color(0xffb6f1bb),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff9bd4a0),
      onColor: Color(0xff003915),
      colorContainer: Color(0xff1b5129),
      onColorContainer: Color(0xffb6f1bb),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff9bd4a0),
      onColor: Color(0xff003915),
      colorContainer: Color(0xff1b5129),
      onColorContainer: Color(0xffb6f1bb),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    warning,
    succes,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}