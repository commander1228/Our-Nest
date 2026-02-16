import 'package:flutter/material.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import '../../../../shared/models/nest.dart';

class NestCard extends StatelessWidget {
  final Nest nest;
  final bool isLoading;
  final VoidCallback? onPressed;

  const NestCard({
    super.key,
    required this.nest,
    required this.onPressed,
    this.isLoading = false, 
    });

  @override
  Widget build(BuildContext context) {
    return  PrimaryButton(
      onPressed: isLoading ? null: onPressed,
      text: nest.name,
    );
  }
}