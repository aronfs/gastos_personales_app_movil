import 'package:gastos_personales/layers/categories/domain/entity/category.dart';

String _string(Map<String, dynamic> json, String key) =>
    (json[key] is String) ? json[key] as String : '';

class CategoryDto extends Category {
  const CategoryDto({
    required super.id,
    required super.userId,
    required super.name,
    required super.icon,
    required super.color,
    required super.type,
  });

  factory CategoryDto.fromMap(Map<String, dynamic> json) {
    final data = json.containsKey('data') && json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;
    return CategoryDto(
      id: _string(data, 'id'),
      userId: _string(data, 'userId'),
      name: _string(data, 'name'),
      icon: _string(data, 'icon'),
      color: _string(data, 'color'),
      type: _string(data, 'type').toUpperCase() == 'INCOME'
          ? CategoryType.income
          : CategoryType.expense,
    );
  }

  Map<String, dynamic> toCreateMap() => {
    'name': name,
    'icon': icon,
    'color': color,
    'type': type == CategoryType.income ? 'INCOME' : 'EXPENSE',
  };

  Map<String, dynamic> toUpdateMap() => {
    'name': name,
    'icon': icon,
    'color': color,
  };

  static List<Category> listFromResponse(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = (raw is List) ? raw : [];
    return list
        .map((e) => CategoryDto.fromMap({'data': e}))
        .toList();
  }
}
