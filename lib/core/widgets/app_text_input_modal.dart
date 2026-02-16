// lib/core/widgets/app_modal.dart
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class AppTextInputModal extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool showCloseButton;

  const AppTextInputModal({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
  });

  /// Shows the modal as a dialog
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool showCloseButton = true,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AppTextInputModal(
        title: title,
        content: content,
        actions: actions,
        showCloseButton: showCloseButton,
      ),
    );
  }

  /// Shows as a bottom sheet
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool showCloseButton = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AppTextInputModal(
          title: title,
          content: content,
          actions: actions,
          showCloseButton: showCloseButton,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.colorScheme.onPrimary,
      title: title != null
          ? Row(
              children: [
                Expanded(child: Text(title!)),
                if (showCloseButton)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
              ],
            )
          : null,
      content: content,
      actions: actions,
    );
  }
}