import '../domain/auth_repository.dart';
import '../data/auth_service.dart';
import '../../../core/auth/token_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService service;
  final TokenStore tokenStore;

  AuthRepositoryImpl(this.service, this.tokenStore);

  @override
  Future<void> login(String email, String password) async {
    final data = await service.login(email, password);
    final access = data['accessToken'] as String?;
    final refresh = data['refreshToken'] as String?;
    if (access == null || refresh == null) throw Exception('Invalid login response');
    await tokenStore.persistTokens(access, refresh);
  }

  @override
  Future<void> register(String email, String password) async {
    final data = await service.register(email, password);
    final access = data['accessToken'] as String?;
    final refresh = data['refreshToken'] as String?;
    if (access == null || refresh == null) throw Exception('Invalid Register response');
    await tokenStore.persistTokens(access, refresh);
  }

  @override
  Future<bool> tryRefresh() async {
    final refresh = await tokenStore.getRefreshToken();
    if (refresh == null) return false;
    try {
      final data = await service.refresh(refresh);
      final access = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String? ?? refresh;
      if (access == null) return false;
      await tokenStore.persistTokens(access, newRefresh);
      return true;
    } catch (_) {
      await tokenStore.clear();
      return false;
    }
  }
}