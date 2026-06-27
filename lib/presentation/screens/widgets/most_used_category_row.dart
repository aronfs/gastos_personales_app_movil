import 'package:flutter/material.dart';
import 'category_item.dart';

/// Fila dentro de la card "Más usadas": icono pequeño, nombre de
/// categoría y monto total alineado a la derecha.
class MostUsedCategoryRow extends StatelessWidget {
  final CategoryItem category;
  final String amountLabel;

  const MostUsedCategoryRow({
    super.key,
    required this.category,
    required this.amountLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: category.backgroundColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(category.icon, size: 16, color: category.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
          Text(
            amountLabel,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
