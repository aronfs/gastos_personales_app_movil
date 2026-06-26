import 'package:gastos_personales/layers/categories/domain/entity/category.dart';

abstract class CategoriesRepository {
  Future<List<Category>> getCategories({CategoryType? type});
  Future<Category> createCategory({
    required String name,
    required String icon,
    required String color,
    required CategoryType type,
  });
  Future<Category> updateCategory({
    required String id,
    required String name,
    required String icon,
    required String color,
  });
  Future<void> deleteCategory(String id);
}
