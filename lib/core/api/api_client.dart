// lib/core/api/api_client.dart
import 'dart:async';
import 'package:dio/dio.dart';
import '../../config.dart';
import '../auth/token_store.dart';

class ApiClient {
  final Dio dio;
  final TokenStore tokenStore;
  bool _isRefreshing = false;

  ApiClient(this.tokenStore)
      : dio = Dio(BaseOptions(
          baseUrl: apiBaseUrl,
          connectTimeout: const Duration(milliseconds: connectTimeoutMs),
          receiveTimeout: const Duration(milliseconds: receiveTimeoutMs),
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStore.getAccessToken();
        if (token != null && options.headers['Authorization'] == null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (err, handler) async {
        final response = err.response;
        final reqOptions = err.requestOptions;

        if (response?.statusCode == 401 && !_isRefreshing && reqOptions.path != '/auth/refresh') {
          _isRefreshing = true;
          try {
            final refreshed = await _refreshToken();
            _isRefreshing = false;
            if (refreshed) {
              final newToken = await tokenStore.getAccessToken();
              if (newToken != null) {
                final opts = Options(
                  method: reqOptions.method,
                  headers: reqOptions.headers..['Authorization'] = 'Bearer $newToken',
                );
                final cloneReq = await dio.request(reqOptions.path,
                    data: reqOptions.data,
                    queryParameters: reqOptions.queryParameters,
                    options: opts);
                handler.resolve(cloneReq);
                return;
              }
            }
          } catch (_) {
            _isRefreshing = false;
          }
        }
        handler.next(err);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    final refresh = await tokenStore.getRefreshToken();
    if (refresh == null) return false;
    try {
      // Use a plain Dio instance without interceptors to avoid recursion.
      final r = await Dio().post('$apiBaseUrl/auth/refresh',
          data: {'refreshToken': refresh});
      final data = r.data as Map<String, dynamic>;
      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;
      if (newAccess != null) {
        await tokenStore.persistTokens(newAccess, newRefresh ?? refresh);
        return true;
      }
    } catch (_) {
      await tokenStore.clear();
      return false;
    }
    return false;
  }
}