import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextField? style;
  final double height;
  final bool fullWidth;
  final Widget? suffixIcon;
  final bool? filled;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.fullWidth = false,
    this.height = 48,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.style,
    this.suffixIcon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: suffixIcon,
          filled:filled,
          fillColor: theme.colorScheme.onPrimary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),// Other properties (border, filled, etc.) come from theme's inputDecorationTheme
        ),
      ),
    );
  }
}

@Preview(name: 'Input Field')
Widget inputFieldPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: InputField(
              label: 'input here',
              controller: TextEditingController(),
            ),
          ),
        ),
      ),
    );