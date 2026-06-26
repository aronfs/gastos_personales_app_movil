import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

class ProfileImageService {
  final Dio _dio;

  ProfileImageService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Uint8List?> getProfileImageFile() async {
    try {
      final token = await TokenStorage.getToken();
      final response = await _dio.get(
        ApiEndpoints.profileImageFile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );
      if (response.statusCode == 200 && response.data is Uint8List) {
        return response.data as Uint8List;
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      return null;
    } catch (_) {
      return null;
    }
  }
}
