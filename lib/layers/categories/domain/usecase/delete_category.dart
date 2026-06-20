import 'package:gastos_personales/layers/categories/domain/repository/categories_repository.dart';

class DeleteCategory {
  final CategoriesRepository _repository;

  DeleteCategory(this._repository);

  Future<void> call(String id) => _repository.deleteCategory(id);
}
