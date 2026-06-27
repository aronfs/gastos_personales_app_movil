import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

class ProfileImageService {
  final Dio _dio;

  ProfileImageService({Dio? dio}) : _dio = dio ?? DioClient().dio;

  Future<Uint8List?> getProfileImageFile() async {
    try {
      final response = await _dio.get(
        ApiEndpoints.profileImageFile,
        options: Options(responseType: ResponseType.bytes),
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
