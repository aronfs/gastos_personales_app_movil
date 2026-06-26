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
    required String name,
    required String icon,
    required String color,
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
    required String name,
    required String icon,
    required String color,
  }) async {
    try {
      final dto = CategoryDto(
        id: id,
        userId: '',
        name: name,
        icon: icon,
        color: color,
        type: CategoryType.expense,
      );
      final response = await _dio.put(
        '${ApiEndpoints.categories}/$id',
        data: dto.toUpdateMap(),
        options: await _authOptions,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return CategoryDto.fromMap(data);
      }

      throw Exception('Error inesperado: ${response.statusCode}');
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final body = e.response?.data;

      String message;
      if (statusCode == 400) {
        message = (body is Map && body['message'] is String)
            ? body['message'] as String
            : 'Solicitud inválida. Verifica los datos.';
      } else if (statusCode == 401) {
        message = 'Sesión expirada. Inicia sesión de nuevo.';
      } else if (statusCode == 404) {
        message = 'La categoría ya no existe.';
      } else if (statusCode != null && statusCode >= 500) {
        message = 'Error del servidor. Intenta más tarde.';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        message = 'Sin conexión a internet.';
      } else {
        message = 'No se pudo actualizar la categoría. Intenta de nuevo.';
      }
      throw Exception(message);
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
