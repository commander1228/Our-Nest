import 'package:flutter/material.dart';
import 'package:test_flutter/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _handleLogin(String email, String password) {
    print('$email,$password');
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
            child: LoginForm(onSubmit: _handleLogin),
            ),
          ],
        )
      ),
    );
  }
}