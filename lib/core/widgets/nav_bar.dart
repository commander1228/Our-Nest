import 'package:flutter/material.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import 'package:test_flutter/core/navigation/navigation_service.dart';

class Bar extends StatelessWidget {
  const Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: NavButton(text: 'Home', onPressed: () => navigationService.goTo('/home'))),
          Expanded(child: NavButton(text: 'Profile', onPressed: () => navigationService.goTo('/profile'))),
          Expanded(child: NavButton(text: 'Settings', onPressed: () => navigationService.goTo('/settings'))),
        ],
      ),
    );
  }
}