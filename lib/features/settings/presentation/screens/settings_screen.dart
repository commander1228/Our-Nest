import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/core/auth/token_store.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Future<void> _logout() async {
    final tokenStore = context.read<TokenStore>();
    await tokenStore.clear();
    navigationService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/', (r) => false);
      return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(onPressed: _logout, text: "logout"),
      )
    );
  }
}