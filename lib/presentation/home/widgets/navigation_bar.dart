import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/l10n/app_localizations.dart';
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
    final cs = Theme.of(context).colorScheme;
    final loc = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: cs.primary,
      unselectedItemColor: cs.onSurfaceVariant,
      selectedLabelStyle: const TextStyle(fontSize: 10),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
      items: menus.map((menu) {
        final label = _labelFor(loc, menu.icono);
        return BottomNavigationBarItem(
          icon: FaIcon(
            iconMap[menu.icono] ?? FontAwesomeIcons.circleQuestion,
            size: 28,
          ),
          label: label,
        );
      }).toList(),
    );
  }

  String _labelFor(AppLocalizations loc, String icono) {
    switch (icono) {
      case 'dashboard':
        return loc.navDashboard;
      case 'movs':
        return loc.navMovements;
      case 'reports':
        return loc.navReports;
      case 'profile':
        return loc.navProfile;
      default:
        return '';
    }
  }
}
