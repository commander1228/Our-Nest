import '../domain/auth_repository.dart';
import '../data/auth_service.dart';
import '../../../core/auth/token_store.dart';
import '../../../shared/models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStore tokenStore;

  AuthRepositoryImpl(this.service, this.tokenStore);

  @override
  Future<void> login(String email, String password) async {
    final req = LoginRequest(email: email, password: password);
    final authResponse = await service.login(req);
    if (authResponse.accessToken.isEmpty || authResponse.refreshToken.isEmpty) {
      throw Exception('Invalid login response');
    }
    await tokenStore.persistTokens(
        authResponse.accessToken, authResponse.refreshToken);
  }

  @override
  Future<void> register(String email, String password) async {
    final req = LoginRequest(email: email, password: password);
    final authResponse = await service.register(req);
    if (authResponse.accessToken.isEmpty || authResponse.refreshToken.isEmpty) {
      throw Exception('Invalid register response');
    }
    await tokenStore.persistTokens(
        authResponse.accessToken, authResponse.refreshToken);
  }

  @override
  Future<bool> tryRefresh() async {
    final refresh = await tokenStore.getRefreshToken();
    if (refresh == null) return false;
    try {
      final authResponse = await service.refresh(refresh);
      final access = authResponse.accessToken;
      final newRefresh = authResponse.refreshToken.isNotEmpty
          ? authResponse.refreshToken
          : refresh;
      if (access.isEmpty) return false;
      await tokenStore.persistTokens(access, newRefresh);
      return true;
    } catch (_) {
      await tokenStore.clear();
      return false;
    }
  }
}
