import 'package:flutter/material.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/navigation/route.dart';
import 'package:gastos_personales/presentation/home/home_page.dart';
import 'package:gastos_personales/presentation/screens/categories_page.dart';
import 'package:gastos_personales/presentation/screens/income_page.dart';
import 'package:gastos_personales/presentation/screens/new_expense_page.dart';
import 'package:gastos_personales/presentation/screens/new_income_page.dart';
import 'package:gastos_personales/presentation/screens/new_product_page.dart';
import 'package:gastos_personales/presentation/screens/scan_barcode_page.dart';
import 'package:gastos_personales/presentation/screens/settings_page.dart';
import 'package:gastos_personales/presentation/screens/supermarket_expense_page.dart';
import 'package:gastos_personales/presentation/screens/widgets/expenses_page.dart';
import 'package:gastos_personales/presentation/session/signin_page.dart';
import 'package:gastos_personales/presentation/session/signup_page.dart';
import 'package:gastos_personales/presentation/splash/splash_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SplashPage(),
        );
      case home:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => HomePage(),
        );
      case signin:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SigninPage(),
        );
      case signup:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => SignupPage(),
        );
      case income:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => IncomePage(),
        );
      case expenses:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ExpensesPage(),
        );
      case categories:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const CategoriesPage(),
        );
      case newExpense:
        final expense = routeSettings.arguments as Movement?;
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => NewExpensePage(expense: expense),
        );
      case newIncome:
        final income = routeSettings.arguments as Movement?;
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => NewIncomePage(income: income),
        );
      case supermarketExpense:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SupermarketExpensePage(),
        );
      case newProduct:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const NewProductPage(),
        );
      case settings:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const SettingsPage(),
        );
      case scanBarcode:
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const ScanBarcodePage(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error'), centerTitle: true),
          body: const Center(
            child: Text(
              'Error ! No se encontro la ventana',
              style: TextStyle(color: Colors.red, fontSize: 18.0),
            ),
          ),
        );
      },
    );
  }
}
