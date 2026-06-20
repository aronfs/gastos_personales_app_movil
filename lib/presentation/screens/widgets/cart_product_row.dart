import 'package:flutter/material.dart';
import 'package:gastos_personales/presentation/screens/bloc/supermarket_form/supermarket_form_bloc.dart';

/// Fila de producto dentro del carrito: icono de caja, nombre/descripción/
/// precio unitario a la izquierda, contador − N + en el centro, y subtotal
/// a la derecha.
class CartProductRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CartProductRow({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEF0F4), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono de caja
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
          // Nombre, descripción, precio unitario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\$ ${item.product.unitPrice.toStringAsFixed(2)} c/u',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9A9DB0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Contador − N +
          Row(
            children: [
              _CounterButton(
                onTap: onDecrement,
                icon: Icons.remove,
                isActive: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${item.quantity}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              _CounterButton(
                onTap: onIncrement,
                icon: Icons.add,
                isActive: true,
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Subtotal
          Text(
            '\$ ${item.subtotal.toStringAsFixed(2)}',
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

class _CounterButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final bool isActive;

  const _CounterButton({
    required this.onTap,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? const Color(0xFF2962FF) : const Color(0xFFEDEEF3),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            icon,
            size: 14,
            color: isActive ? Colors.white : const Color(0xFF4A4D5E),
          ),
        ),
      ),
    );
  }
}
