import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/layers/products/data/source/network/products_api.dart';
import 'package:gastos_personales/layers/products/domain/repository/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsApi _api;

  ProductsRepositoryImpl(this._api);

  @override
  Future<List<Product>> getProducts({String? categoryId}) =>
      _api.getProducts(categoryId: categoryId);

  @override
  Future<Product> createProduct({
    required String categoryId,
    required String name,
    required String description,
    required double unitPrice,
  }) =>
      _api.createProduct({
        'categoryId': categoryId,
        'name': name,
        'description': description,
        'unitPrice': unitPrice,
      });
}
