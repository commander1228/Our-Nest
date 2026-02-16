import 'package:flutter/material.dart';
import 'package:test_flutter/features/auth/presentation/widgets/register_form.dart';
import 'package:test_flutter/features/auth/domain/auth_repository.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isLoading = false;

  Future<void> _handleRegister(String email, String password) async {
    setState(() => _isLoading = true);
    final authRepo = context.read<AuthRepository>();
    try {
      await authRepo.register(email, password);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registered successfully')));
      navigationService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/home', (r) => false);
      return;
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
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
            Text('Register',style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
            child: RegisterForm(onSubmit: _handleRegister, isLoading: _isLoading),
            ),
          ],
        )
      ),
    );
  }
}