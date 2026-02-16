import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/models/login_request.dart';
import '../../../shared/models/auth_response.dart';

class AuthService {
  final ApiClient api;
  AuthService(this.api);

  Future<AuthResponse> login(LoginRequest req) async {
    final r = await api.dio.post('/auth/login', data: req.toJson());
    return AuthResponse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<AuthResponse> register(LoginRequest req) async {
    final r = await api.dio.post('/auth/register', data: req.toJson());
    return AuthResponse.fromJson(r.data as Map<String, dynamic>);
  }

  Future<AuthResponse> refresh(String refreshToken) async {
    final r = await api.dio
        .post('/auth/refresh', data: {'refreshToken': refreshToken});
    return AuthResponse.fromJson(r.data as Map<String, dynamic>);
  }
}
