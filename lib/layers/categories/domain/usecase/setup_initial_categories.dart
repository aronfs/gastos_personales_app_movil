import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/usecase/create_category.dart';

class SetupInitialCategories {
  final CreateCategory _createCategory;

  SetupInitialCategories(this._createCategory);

  Future<List<Category>> call() async {
    const defaults = [
      _Default(name: 'Salario', icon: 'salary', color: '#3b82f6', type: CategoryType.income),
      _Default(name: 'Alimentación', icon: 'restaurant', color: '#ef4444', type: CategoryType.expense),
      _Default(name: 'Transporte', icon: 'transport', color: '#f97316', type: CategoryType.expense),
    ];

    final results = <Category>[];
    for (final d in defaults) {
      final category = await _createCategory(
        name: d.name,
        icon: d.icon,
        color: d.color,
        type: d.type,
      );
      results.add(category);
    }
    return results;
  }
}

class _Default {
  final String name;
  final String icon;
  final String color;
  final CategoryType type;

  const _Default({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });
}
