import 'package:flutter/material.dart';

/// Modelo UI para mostrar una categoría en el grid.
class CategoryDisplay {
  final String? id;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final String name;

  const CategoryDisplay({
    this.id,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.name,
  });
}

typedef CategoryItem = CategoryDisplay;
