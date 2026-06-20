
import 'package:gastos_personales/presentation/home/model/menu_model.dart';

final List<String> menuRoutes = [
  '/pages/dashboard',
  '/pages/movements',
  '',
  '/pages/reports',
  '/pages/profile',
];

final List<MenuModel> menus = [
  MenuModel(
    idMenu: 1,
    nombre: 'Inicio',
    icono: 'dashboard',
    url: '/pages/dashboard',
  ),
  MenuModel(
    idMenu: 2,
    nombre: 'Movimientos',
    icono: 'movs',
    url: '/pages/movements',
  ),
  MenuModel(
    idMenu: 3,
    nombre: '',
    icono: '',
    url: '',
  ),
   MenuModel(
    idMenu: 4,
    nombre: 'Reportes',
    icono: 'reports',
    url: '/pages/reports',
  ),
  MenuModel(
    idMenu: 5,
    nombre: 'Perfil',
    icono: 'profile',
    url: '/pages/profile',
  ),
];