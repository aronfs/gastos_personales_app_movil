import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/presentation/home/model/menu_model.dart';
import 'package:gastos_personales/presentation/home/widgets/menu_bar.dart';

class NavigationBarCustom extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<MenuModel> menus;

  const NavigationBarCustom({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: menus.map((menu) {
        return BottomNavigationBarItem(
          icon: FaIcon(
            iconMap[menu.icono] ?? FontAwesomeIcons.circleQuestion,
            size: 28,
          ),
          label: menu.nombre,
        );
      }).toList(),
    );
  }
}
