import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/token_store.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../navigation/navigation_service.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});
  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final tokenStore = context.read<TokenStore>();
    final authRepo = context.read<AuthRepository>();

    final access = await tokenStore.getAccessToken();
    if (access != null) {
      navigationService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/home', (r) => false);
      return;
    }

    final refresh = await tokenStore.getRefreshToken();
    if (refresh != null) {
      final refreshed = await authRepo.tryRefresh();
      if (refreshed) {
        navigationService.navigatorKey.currentState
            ?.pushNamedAndRemoveUntil('/home', (r) => false);
        return;
      }
    }

    navigationService.navigatorKey.currentState?.pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}