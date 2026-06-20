import 'package:flutter/material.dart';

IconData iconFromString(String name) {
  const icons = <String, IconData>{
    'restaurant': Icons.restaurant_outlined,
    'car': Icons.directions_car_outlined,
    'transport': Icons.directions_car_outlined,
    'health': Icons.favorite_border,
    'coffee': Icons.local_cafe_outlined,
    'shopping': Icons.shopping_bag_outlined,
    'tech': Icons.smartphone_outlined,
    'work': Icons.work_outline,
    'freelance': Icons.language,
    'wallet': Icons.account_balance_wallet_outlined,
    'salary': Icons.work_outline,
    'family': Icons.favorite_border,
    'pharmacy': Icons.local_pharmacy_outlined,
    'gym': Icons.fitness_center_outlined,
    'sell': Icons.sell_outlined,
    'calendar': Icons.calendar_today_outlined,
    'default': Icons.category_outlined,
  };

  final key = name.toLowerCase().replaceAll('_', '');
  return icons.entries
          .firstWhere(
            (e) => key.contains(e.key) || e.key.contains(key),
            orElse: () => const MapEntry('default', Icons.category_outlined),
          )
          .value;
}
