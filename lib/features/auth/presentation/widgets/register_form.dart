import 'package:flutter/material.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import 'package:test_flutter/core/widgets/input_field.dart';
import 'package:flutter/widget_previews.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';

class RegisterForm extends StatefulWidget {
  final void Function(String email, String password) onSubmit;
  final bool isLoading;

  const RegisterForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
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
          text: 'Sign Up',
          isLoading: widget.isLoading,
        ),
        const SizedBox(height: 16),
        NavButton(
          onPressed: () => navigationService.goTo("/login"),
          text: 'Back to Login',
        ),
      ],
    );
  }
}

@Preview(name: 'Register Form')
Widget RegisterFormPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: RegisterForm(
                onSubmit: (email, password) {},
              ),
            ),
          ),
        ),
      ),
    );

@Preview(name: 'Register Form Loading')
Widget RegisterFormLoadingPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: RegisterForm(
                onSubmit: (email, password) {},
                isLoading: true,
              ),
            ),
          ),
        ),
      ),
    );