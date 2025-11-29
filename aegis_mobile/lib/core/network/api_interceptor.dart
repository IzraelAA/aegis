import 'package:dio/dio.dart';
import 'package:aegis_mobile/core/local_storage/hive_storage.dart';
import 'package:aegis_mobile/core/di/injection.dart';
import 'package:aegis_mobile/core/network/api_endpoints.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final storage = getIt<HiveStorage>();
    final token = storage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - try to refresh token
    if (err.response?.statusCode == 401) {
      final storage = getIt<HiveStorage>();
      final refreshToken = storage.getRefreshToken();

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          // Attempt to refresh token
          final dio = Dio();
          final response = await dio.post(
            '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newToken = response.data['access_token'] as String?;
            final newRefreshToken = response.data['refresh_token'] as String?;

            if (newToken != null) {
              await storage.saveToken(newToken);
              if (newRefreshToken != null) {
                await storage.saveRefreshToken(newRefreshToken);
              }

              // Retry the original request with new token
              err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await dio.fetch(err.requestOptions);
              return handler.resolve(retryResponse);
            }
          }
        } catch (_) {
          // Refresh failed, clear session
          await storage.clearSession();
        }
      } else {
        // No refresh token, clear session
        await storage.clearSession();
      }
    }

    super.onError(err, handler);
  }
}
