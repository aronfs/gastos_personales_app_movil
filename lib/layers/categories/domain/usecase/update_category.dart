import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';

class UpdateCategory {
  final CategoriesRepository _repository;

  UpdateCategory(this._repository);

  Future<Category> call({
    required String id,
    String? name,
    String? icon,
    String? color,
  }) =>
      _repository.updateCategory(id: id, name: name, icon: icon, color: color);
}
