import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/domain/repository/products_repository.dart';

class GetProducts {
  final ProductsRepository _repository;

  GetProducts(this._repository);

  Future<List<Product>> call({String? categoryId}) =>
      _repository.getProducts(categoryId: categoryId);
}
