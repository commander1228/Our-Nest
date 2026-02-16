import '../../../shared/models/auth_response.dart';
import '../../../shared/models/login_request.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password);
  Future<bool> tryRefresh();
}