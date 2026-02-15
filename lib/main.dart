import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';


import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert';

import 'package:test_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:test_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import "core/navigation/navigation_service.dart";
 // For jsonDecode

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
   final ThemeData theme;
  const MyApp({super.key, required this.theme});


  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    navigatorKey: navigationService.navigatorKey,
    home: const MyHomePage(title: 'Home Page'),
    theme: theme,
    routes: {
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
    },
  );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: 
        ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Basic Flutter App',style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 88),
            NavButton(onPressed:() => navigationService.goTo("/login") , text: 'Login'),
            const SizedBox(height: 48),
            NavButton(onPressed:() => navigationService.goTo("/register") , text: 'Sign Up'),
          ],
        ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
