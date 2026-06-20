import 'package:flutter/material.dart';

/// Card de "Producto detectado": fondo oscuro, etiqueta "PRODUCTO
/// DETECTADO", icono circular azul con tag, nombre del producto,
/// SKU · tienda, precio a la derecha, y dos botones: "Editar"
/// (outline) y "Agregar al gasto" (azul sólido).
class DetectedProductCard extends StatelessWidget {
  final String productName;
  final String sku;
  final String store;
  final String price;
  final VoidCallback? onEdit;
  final VoidCallback? onAddToExpense;
  final String actionLabel;

  const DetectedProductCard({
    super.key,
    required this.productName,
    required this.sku,
    required this.store,
    required this.price,
    this.onEdit,
    this.onAddToExpense,
    this.actionLabel = 'Agregar al gasto',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF151829),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label "PRODUCTO DETECTADO"
          const Text(
            'PRODUCTO\nDETECTADO',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5A5F7A),
              letterSpacing: 0.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Fila: icono + info + precio
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono circular azul
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A3566),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.sell_outlined,
                  size: 20,
                  color: Color(0xFF4A8CFF),
                ),
              ),
              const SizedBox(width: 12),
              // Nombre y SKU
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$sku · $store',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF5A5F7A),
                      ),
                    ),
                  ],
                ),
              ),
              // Precio
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Precio',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF5A5F7A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Botones
          Row(
            children: [
              Expanded(
                child: _OutlineButton(
                  label: 'Editar',
                  onTap: onEdit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _SolidButton(
                  label: actionLabel,
                  onTap: onAddToExpense,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _OutlineButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2E3350), width: 1.5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SolidButton({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2F6BFF),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
