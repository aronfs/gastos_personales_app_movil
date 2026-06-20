import 'package:flutter/material.dart';
import 'category_share.dart';

/// Fila individual de la leyenda de categorías: punto de color, nombre
/// y porcentaje alineado a la derecha.
class CategoryLegendRow extends StatelessWidget {
  final CategoryShare category;

  const CategoryLegendRow({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A4D5E),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${category.percentage.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}
