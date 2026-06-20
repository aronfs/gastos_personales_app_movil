import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';

abstract class ProductsRepository {
  Future<List<Product>> getProducts({String? categoryId});
  Future<Product> createProduct({
    required String categoryId,
    required String name,
    required String description,
    required double unitPrice,
  });
}
