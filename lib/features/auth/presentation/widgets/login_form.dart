import 'package:flutter/material.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import 'package:test_flutter/core/widgets/input_field.dart';
import 'package:flutter/widget_previews.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';

class LoginForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = 'Email is required');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = 'Password is required');
      return;
    }

    widget.onSubmit(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InputField(
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          errorText: _emailError,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: _passwordController,
          label: 'Password',
          obscureText: _obscurePassword,
          errorText: _passwordError,
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          onPressed: _submit,
          text: 'Login',
          isLoading: widget.isLoading,
        ),
        const SizedBox(height: 16),
        NavButton(
          onPressed: () => navigationService.goTo("/register"),
          text: 'Create New Account',
        ),
      ],
    );
  }
}

@Preview(name: 'Login Form')
Widget loginFormPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: LoginForm(
                onSubmit: (email, password) {},
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'Login Form Loading')
Widget loginFormLoadingPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: LoginForm(
                onSubmit: (email, password) {},
                isLoading: true,
              ),
            ),
          ),
        ),
      ),
    );