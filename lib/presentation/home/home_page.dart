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
          onPressed: () => _showQuickActions(context),
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

  void _showQuickActions(BuildContext context) {
    Navigator.pushNamed(context, quickActions);
  }
}
