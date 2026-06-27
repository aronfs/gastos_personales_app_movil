import 'package:dio/dio.dart';
import 'package:gastos_personales/util/api_endpoints.dart';
import 'package:gastos_personales/util/token_storage.dart';

class DioClient {
  DioClient._();

  static final DioClient _instance = DioClient._();
  factory DioClient() => _instance;

  static Dio _createDio() {
    final dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
    dio.interceptors.add(_AuthInterceptor());
    return dio;
  }

  final Dio dio = _createDio();
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains('/auth/refresh')) {
      await TokenStorage.clearAll();
      return handler.next(err);
    }

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await TokenStorage.clearAll();
        return handler.next(err);
      }

      final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final refreshResponse = await refreshDio.post(
        ApiEndpoints.authRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = refreshResponse.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['accessToken'] as String;
      final newRefreshToken = data['refreshToken'] as String;

      await TokenStorage.saveToken(newAccessToken);
      await TokenStorage.saveRefreshToken(newRefreshToken);

      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final response = await Dio().fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (_) {
      await TokenStorage.clearAll();
      return handler.next(err);
    }
  }
}
