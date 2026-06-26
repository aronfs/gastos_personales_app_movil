import 'package:flutter/material.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/home/data.dart';
import 'package:gastos_personales/presentation/home/widgets/menu_bar.dart';
import 'package:gastos_personales/presentation/home/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentRoute = menuRoutes[selectedIndex];

    return Scaffold(
      body: menuWidgets[currentRoute],

      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () => _showAddMenu(context),
          child: const Icon(Icons.add, size: 32),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: NavigationBarCustom(
        selectedIndex: selectedIndex,
        onItemTapped: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        menus: menus,
      ),
    );
  }

  void _showAddMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: Color(0xFF34C759)),
              title: const Text('Nuevo ingreso'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, newIncome);
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: Color(0xFF2962FF)),
              title: const Text('Nuevo gasto'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, newExpense);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined, color: Color(0xFFC8923B)),
              title: const Text('Gasto supermercado'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, supermarketExpense);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2_outlined, color: Color(0xFF9A9DB0)),
              title: const Text('Nuevo producto'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, newProduct);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner, color: Color(0xFF673AB7)),
              title: const Text('Escanear producto'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pushNamed(context, scanBarcode);
              },
            ),
          ],
        ),
      ),
    );
  }
}
