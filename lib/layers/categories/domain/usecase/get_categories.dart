import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';

class GetCategories {
  final CategoriesRepository _repository;

  GetCategories(this._repository);

  Future<List<Category>> call({CategoryType? type}) =>
      _repository.getCategories(type: type);
}
