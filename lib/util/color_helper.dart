import 'package:flutter/material.dart';

const Map<String, String> colorHexToName = {
  '#0ea5e9': 'Azul cielo',
  '#3b82f6': 'Azul',
  '#1d4ed8': 'Azul marino',
  '#ef4444': 'Rojo',
  '#dc2626': 'Rojo intenso',
  '#22c55e': 'Verde',
  '#16a34a': 'Verde oscuro',
  '#86efac': 'Verde claro',
  '#f97316': 'Naranja',
  '#ff7d45': 'Naranja claro',
  '#a855f7': 'Morado',
  '#7c3aed': 'Púrpura',
  '#ec4899': 'Rosa',
  '#f472b6': 'Rosa claro',
  '#06b6d4': 'Cian',
  '#14b8a6': 'Turquesa',
  '#eab308': 'Ámbar',
  '#84cc16': 'Lima',
  '#6b7280': 'Gris',
  '#78350f': 'Marrón',
};

const Map<String, String> _colorNameToHex = {
  'Azul cielo': '#0ea5e9',
  'Azul': '#3b82f6',
  'Azul marino': '#1d4ed8',
  'Rojo': '#ef4444',
  'Rojo intenso': '#dc2626',
  'Verde': '#22c55e',
  'Verde oscuro': '#16a34a',
  'Verde claro': '#86efac',
  'Naranja': '#f97316',
  'Naranja claro': '#ff7d45',
  'Morado': '#a855f7',
  'Púrpura': '#7c3aed',
  'Rosa': '#ec4899',
  'Rosa claro': '#f472b6',
  'Cian': '#06b6d4',
  'Turquesa': '#14b8a6',
  'Ámbar': '#eab308',
  'Lima': '#84cc16',
  'Gris': '#6b7280',
  'Marrón': '#78350f',
};

class ColorInfo {
  final String name;
  final String hex;
  Color get color => colorFromHex(hex);

  const ColorInfo(this.name, this.hex);
}

const List<ColorInfo> colorOptions = [
  ColorInfo('Azul cielo', '#0ea5e9'),
  ColorInfo('Azul', '#3b82f6'),
  ColorInfo('Azul marino', '#1d4ed8'),
  ColorInfo('Rojo', '#ef4444'),
  ColorInfo('Rojo intenso', '#dc2626'),
  ColorInfo('Verde', '#22c55e'),
  ColorInfo('Verde oscuro', '#16a34a'),
  ColorInfo('Verde claro', '#86efac'),
  ColorInfo('Naranja', '#f97316'),
  ColorInfo('Naranja claro', '#ff7d45'),
  ColorInfo('Morado', '#a855f7'),
  ColorInfo('Púrpura', '#7c3aed'),
  ColorInfo('Rosa', '#ec4899'),
  ColorInfo('Rosa claro', '#f472b6'),
  ColorInfo('Cian', '#06b6d4'),
  ColorInfo('Turquesa', '#14b8a6'),
  ColorInfo('Ámbar', '#eab308'),
  ColorInfo('Lima', '#84cc16'),
  ColorInfo('Gris', '#6b7280'),
  ColorInfo('Marrón', '#78350f'),
];

Color colorFromHex(String hex) {
  var value = hex.replaceAll('#', '');
  if (value.length == 6) value = 'FF$value';
  return Color(int.parse(value, radix: 16));
}

String colorToHex(Color color) =>
    '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

String nameFromHex(String hex) {
  final upper = hex.toUpperCase();
  for (final entry in colorHexToName.entries) {
    if (entry.key.toUpperCase() == upper) return entry.value;
  }
  return colorOptions.first.name;
}

String hexFromName(String name) {
  return _colorNameToHex[name] ?? colorOptions.first.hex;
}

Color colorFromName(String name) => colorFromHex(hexFromName(name));
