import 'package:flutter/material.dart';

/// Card de "Vista previa" que muestra cómo lucirá el producto
/// una vez creado: icono, nombre, descripción y precio.
class ProductPreviewCard extends StatelessWidget {
  final String name;
  final String description;
  final String priceLabel;

  const ProductPreviewCard({
    super.key,
    required this.name,
    required this.description,
    required this.priceLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E6F0), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VISTA PREVIA',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9A9DB0),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: Color(0xFF4A4D5E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? 'Nombre del producto' : name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description.isEmpty
                          ? 'Descripción'
                          : description,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF9A9DB0),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                priceLabel.isEmpty ? '\$ 0.00' : priceLabel,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E9E4F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
