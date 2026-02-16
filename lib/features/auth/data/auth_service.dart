import '../../../core/api/api_client.dart';

class AuthService {
  final ApiClient api;
  AuthService(this.api);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final r = await api.dio.post('/auth/login', data: {'email': email, 'password': password});
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final r = await api.dio.get('/auth/register');
    return r.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final r = await api.dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
    return r.data as Map<String, dynamic>;
  }
}