import 'package:gastos_personales/layers/categories/data/source/network/categories_api.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesApi _api;

  CategoriesRepositoryImpl(this._api);

  @override
  Future<List<Category>> getCategories({CategoryType? type}) =>
      _api.getCategories(type: type);

  @override
  Future<Category> createCategory({
    required String name,
    required String icon,
    required String color,
    required CategoryType type,
  }) => _api.createCategory(name: name, icon: icon, color: color, type: type);

  @override
  Future<Category> updateCategory({
    required String id,
    String? name,
    String? icon,
    String? color,
  }) => _api.updateCategory(id: id, name: name, icon: icon, color: color);

  @override
  Future<void> deleteCategory(String id) => _api.deleteCategory(id);
}
