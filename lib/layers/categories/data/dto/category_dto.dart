import 'package:gastos_personales/layers/categories/domain/entity/category.dart';

class CategoryDto extends Category {
  const CategoryDto({
    required super.id,
    required super.userId,
    required super.name,
    required super.icon,
    required super.color,
    required super.type,
  });

  factory CategoryDto.fromMap(Map<String, dynamic> json) => CategoryDto(
    id: json['id'] as String,
    userId: json['userId'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String,
    color: json['color'] as String,
    type: (json['type'] as String).toUpperCase() == 'INCOME'
        ? CategoryType.income
        : CategoryType.expense,
  );

  Map<String, dynamic> toCreateMap() => {
    'name': name,
    'icon': icon,
    'color': color,
    'type': type == CategoryType.income ? 'INCOME' : 'EXPENSE',
  };

  Map<String, dynamic> toUpdateMap() => {
    if (name.isNotEmpty) 'name': name,
    if (icon.isNotEmpty) 'icon': icon,
    if (color.isNotEmpty) 'color': color,
  };

  static List<Category> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'] as List;
    return data
        .map((e) => CategoryDto.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
