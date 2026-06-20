import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';

class CreateCategory {
  final CategoriesRepository _repository;

  CreateCategory(this._repository);

  Future<Category> call({
    required String name,
    required String icon,
    required String color,
    required CategoryType type,
  }) => _repository.createCategory(
    name: name,
    icon: icon,
    color: color,
    type: type,
  );
}
