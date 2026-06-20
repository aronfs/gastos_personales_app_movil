import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/incomes/domain/entity/income.dart';
import 'package:gastos_personales/presentation/screens/widgets/category_item.dart';
import 'package:gastos_personales/presentation/screens/widgets/transaction_entry.dart';
import 'package:gastos_personales/util/color_helper.dart';
import 'package:gastos_personales/util/icon_helper.dart';
import 'package:intl/intl.dart';

TransactionEntry movementToEntry(Movement movement, {bool isIncome = false}) {
  final color = colorFromHex(movement.category.color);
  final date = _formatDate(movement.transactionDate);
  final sign = isIncome ? '+' : '-';

  return TransactionEntry(
    id: movement.id,
    icon: iconFromString(movement.category.icon),
    iconBackgroundColor: color.withValues(alpha: 0.15),
    iconColor: color,
    title: movement.description,
    subtitle: '${movement.category.name} · $date',
    amountLabel: '$sign\$ ${movement.amount.toStringAsFixed(2)}',
    isPositive: isIncome,
  );
}

TransactionEntry incomeToEntry(Income income) {
  final color = colorFromHex(income.category.color);
  final date = DateFormat('dd MMM', 'es').format(income.transactionDate);

  return TransactionEntry(
    id: income.id,
    icon: iconFromString(income.category.icon),
    iconBackgroundColor: color.withValues(alpha: 0.15),
    iconColor: color,
    title: income.description,
    subtitle: '${income.category.name} · $date',
    amountLabel: '+\$ ${income.amount.toStringAsFixed(2)}',
    isPositive: true,
  );
}

CategoryDisplay categoryToDisplay(Category category) {
  final color = colorFromHex(category.color);
  return CategoryDisplay(
    id: category.id,
    icon: iconFromString(category.icon),
    backgroundColor: color.withValues(alpha: 0.15),
    iconColor: color,
    name: category.name,
  );
}

String _formatDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    return DateFormat('dd MMM', 'es').format(date);
  } catch (_) {
    return isoDate;
  }
}

String formatDisplayDate(DateTime date) =>
    DateFormat('dd MMM yyyy', 'es').format(date);

String formatApiDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

Map<String, List<Movement>> groupByDate(List<Movement> movements) {
  final grouped = <String, List<Movement>>{};
  for (final movement in movements) {
    grouped.putIfAbsent(movement.transactionDate, () => []).add(movement);
  }
  return grouped;
}

String dateGroupLabel(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final formatted = DateFormat('dd MMM', 'es').format(date);

    if (target == today) return 'Hoy · $formatted';
    if (target == today.subtract(const Duration(days: 1))) {
      return 'Ayer · $formatted';
    }
    return formatted;
  } catch (_) {
    return isoDate;
  }
}
