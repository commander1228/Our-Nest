import 'package:flutter/material.dart';
import 'package:test_flutter/features/auth/presentation/widgets/login_form.dart';
import 'package:test_flutter/features/auth/domain/auth_repository.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool _isLoading = false;

  Future<void> _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);
    final authRepo = context.read<AuthRepository>();
    try {
      await authRepo.login(email, password);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successfull')));
      navigationService.goTo('/login');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Login',style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
            child: LoginForm(onSubmit: _handleLogin, isLoading: _isLoading),
            ),
          ],
        )
      ),
    );
  }
}