import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;
  final ValueNotifier<bool> navigating = ValueNotifier(false);

  NavigationService(this.navigatorKey);

  Future<void> goTo(String route) async {
    if (navigating.value) return;
    navigating.value = true;
    try {
      final state = navigatorKey.currentState;
      if (state == null) {
        return;
      }
      state.pushNamed(route);
    } finally {
      // could use this or something similar in prod
    //   Future.delayed(const Duration(milliseconds: 300), () {
    //   navigating.value = false;
    // });
      navigating.value = false;
    }
  }
}

final navigationService = NavigationService(navigatorKey);