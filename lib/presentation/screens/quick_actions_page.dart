import 'package:flutter/material.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/screens/widgets/settings_app_bar.dart';

class QuickActionsPage extends StatelessWidget {
  const QuickActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SettingsAppBar(title: 'Acciones rápidas'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '¿Qué deseas hacer?',
                style: TextStyle(
                  fontSize: 14,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.0,
                children: [
                  _ActionCard(
                    icon: Icons.arrow_downward,
                    label: 'Nuevo ingreso',
                    description: 'Registrar un ingreso',
                    color: cs.tertiary,
                    onTap: () => Navigator.pushNamed(context, newIncome),
                  ),
                  _ActionCard(
                    icon: Icons.arrow_upward,
                    label: 'Nuevo gasto',
                    description: 'Registrar un gasto',
                    color: cs.primary,
                    onTap: () => Navigator.pushNamed(context, newExpense),
                  ),
                  _ActionCard(
                    icon: Icons.shopping_cart_outlined,
                    label: 'Gasto supermercado',
                    description: 'Compra en supermercado',
                    color: const Color(0xFFC8923B),
                    onTap: () => Navigator.pushNamed(context, supermarketExpense),
                  ),
                  _ActionCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Nuevo producto',
                    description: 'Agregar un producto',
                    color: cs.onSurfaceVariant,
                    onTap: () => Navigator.pushNamed(context, newProduct),
                  ),
                  _ActionCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Escanear producto',
                    description: 'Leer código de barras',
                    color: const Color(0xFF673AB7),
                    onTap: () => Navigator.pushNamed(context, scanBarcode),
                  ),
                  _ActionCard(
                    icon: Icons.receipt_long_outlined,
                    label: 'Escanear facturas',
                    description: 'OCR para facturas',
                    color: cs.tertiary,
                    onTap: () => Navigator.pushNamed(context, receiptScanner),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(20),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 14),
          child: Column(
            children: [
              // Icon circle grande y centrado
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.35),
                      color.withValues(alpha: 0.08),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 14),
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Descripción
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
