import 'package:dio/dio.dart';
import 'package:gastos_personales/data/dio_client.dart';
import 'package:gastos_personales/util/api_endpoints.dart';

abstract class ProfileApi {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile(String firstName, String lastName);
  Future<void> deactivateProfile(String confirmation);

  Future<Map<String, dynamic>> getProfileImageMetadata();
  Future<Map<String, dynamic>> uploadProfileImage(String filePath);
  Future<void> deleteProfileImage(String confirmation);
}

class ProfileApiImpl implements ProfileApi {
  final Dio _dio = DioClient().dio;

  @override
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.profile);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load profile');
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(String firstName, String lastName) async {
    try {
      final response = await _dio.put(
        ApiEndpoints.profile,
        data: {'first_name': firstName, 'last_name': lastName},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to update profile');
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deactivateProfile(String confirmation) async {
    try {
      await _dio.patch(
        ApiEndpoints.profileDeactivate,
        data: {'confirmation': confirmation},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to deactivate profile');
    } catch (e) {
      throw Exception('Failed to deactivate profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileImageMetadata() async {
    try {
      final response = await _dio.get(ApiEndpoints.profileImage);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to load image metadata');
    } catch (e) {
      throw Exception('Failed to load image metadata: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> uploadProfileImage(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        ApiEndpoints.profileImage,
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to upload image');
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Future<void> deleteProfileImage(String confirmation) async {
    try {
      await _dio.delete(
        ApiEndpoints.profileImage,
        data: {'confirmation': confirmation},
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to delete image');
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
