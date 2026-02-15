import 'package:flutter/material.dart';
import 'package:test_flutter/features/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  void _handleRegister(String email, String password) {
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
            Text('Register',style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
            child: RegisterForm(onSubmit: _handleRegister),
            ),
          ],
        )
      ),
    );
  }
}