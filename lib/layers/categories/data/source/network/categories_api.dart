import 'package:dio/dio.dart';
import 'package:gastos_personales/layers/categories/data/dto/category_dto.dart';
import 'package:gastos_personales/layers/categories/domain/entity/category.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

abstract class CategoriesApi {
  Future<List<Category>> getCategories({CategoryType? type});
  Future<Category> createCategory({
    required String name,
    required String icon,
    required String color,
    required CategoryType type,
  });
  Future<Category> updateCategory({
    required String id,
    String? name,
    String? icon,
    String? color,
  });
  Future<void> deleteCategory(String id);
}

class CategoriesApiImpl implements CategoriesApi {
  final Dio _dio = Dio();

  Future<Options> get _authOptions async {
    final token = await TokenStorage.getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<Category>> getCategories({CategoryType? type}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.categories,
        queryParameters: {
          if (type != null)
            'type': type == CategoryType.income ? 'INCOME' : 'EXPENSE',
        },
        options: await _authOptions,
      );
      return CategoryDto.listFromResponse(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        'Categories error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Category> createCategory({
    required String name,
    required String icon,
    required String color,
    required CategoryType type,
  }) async {
    try {
      final dto = CategoryDto(
        id: '',
        userId: '',
        name: name,
        icon: icon,
        color: color,
        type: type,
      );
      final response = await _dio.post(
        ApiEndpoints.categories,
        data: dto.toCreateMap(),
        options: await _authOptions,
      );
      // La API devuelve el objeto creado directamente
      final data = response.data as Map<String, dynamic>;
      return CategoryDto.fromMap(data);
    } on DioException catch (e) {
      throw Exception(
        'Create category error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<Category> updateCategory({
    required String id,
    String? name,
    String? icon,
    String? color,
  }) async {
    try {
      final dto = CategoryDto(
        id: id,
        userId: '',
        name: name ?? '',
        icon: icon ?? '',
        color: color ?? '',
        type: CategoryType.expense, // placeholder, no se envía en update
      );
      final response = await _dio.patch(
        '${ApiEndpoints.categories}/$id',
        data: dto.toUpdateMap(),
        options: await _authOptions,
      );
      final data = response.data as Map<String, dynamic>;
      return CategoryDto.fromMap(data);
    } on DioException catch (e) {
      throw Exception(
        'Update category error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _dio.delete(
        '${ApiEndpoints.categories}/$id',
        options: await _authOptions,
      );
    } on DioException catch (e) {
      throw Exception(
        'Delete category error: ${e.response?.statusCode} ${e.message}',
      );
    }
  }
}
