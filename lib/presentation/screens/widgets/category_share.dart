import 'package:flutter/material.dart';

/// Representa una categoría de gasto con su porcentaje y color asociado.
class CategoryShare {
  final String name;
  final double percentage; // 0-100
  final Color color;

  const CategoryShare({
    required this.name,
    required this.percentage,
    required this.color,
  });
}
