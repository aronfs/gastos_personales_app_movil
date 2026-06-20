import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastos_personales/presentation/screens/dashboard_page.dart';
import 'package:gastos_personales/presentation/screens/movements_page.dart';
import 'package:gastos_personales/presentation/screens/profile_page.dart';
import 'package:gastos_personales/presentation/screens/reports_page.dart';

final Map<String, Widget> menuWidgets = {
  '/pages/dashboard': DashboardPage(),
  '/pages/movements': MovementsPage(),
  '/pages/profile': ProfilePage(),
  '/pages/reports': ReportsPage(),
};

final Map<String, FaIconData> iconMap = {
  'dashboard': FontAwesomeIcons.house,
  'movs': FontAwesomeIcons.wallet,
  'reports': FontAwesomeIcons.chartLine,
  'profile': FontAwesomeIcons.user,
};