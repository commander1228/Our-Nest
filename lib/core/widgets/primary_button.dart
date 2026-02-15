import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double height;
  final bool fullWidth;
  final ButtonStyle? style;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.height = 48,
    this.fullWidth = true,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      textStyle: theme.textTheme.labelLarge,
      minimumSize: Size.fromHeight(height),
    );
    return  SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: style ?? defaultStyle,
        child: isLoading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('Please wait...'),
                ],
              )
            : Text(text, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const NavButton({this.onPressed, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: navigationService.navigating,
      builder: (_, navigating, __) => PrimaryButton(
        onPressed: navigating ? null : onPressed,
        text: text,
      ),
    );
  }
}

@Preview(name: 'Primary Button')
Widget primaryButtonPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              onPressed: () {},
              text: 'Click Me',
            ),
          ),
        ),
      ),
    );

@Preview(name: 'Primary Button Loading')
Widget primaryButtonLoadingPreview() => MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              onPressed: () {},
              text: 'Click Me',
              isLoading: true,
            ),
          ),
        ),
      ),
    );