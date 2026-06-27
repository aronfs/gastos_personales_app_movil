import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/layers/movements/data/dto/movement_dto.dart';
import 'package:gastos_personales/layers/movements/domain/entity/movement.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class ProductsApi {
  Future<List<Product>> getProducts({String? categoryId});
  Future<Product> createProduct(Map<String, dynamic> body);
}

class ProductsApiImpl implements ProductsApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<Product>> getProducts({String? categoryId}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.product,
        queryParameters: categoryId != null ? {'categoryId': categoryId} : null,
      );
      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data.map((e) => ProductDto.fromMap(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(
        'Get products error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> body) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.product,
        data: body,
      );
      return ProductDto.fromMap(
        (response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Create product error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
