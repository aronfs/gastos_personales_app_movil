import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/domain/repository/products_repository.dart';

class CreateProduct {
  final ProductsRepository _repository;

  CreateProduct(this._repository);

  Future<Product> call({
    required String categoryId,
    required String name,
    required String description,
    required double unitPrice,
  }) =>
      _repository.createProduct(
        categoryId: categoryId,
        name: name,
        description: description,
        unitPrice: unitPrice,
      );
}
