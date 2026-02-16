import 'package:flutter/material.dart';
import 'package:json_theme/json_theme.dart';


import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:test_flutter/core/logger/logger.dart';
import 'package:test_flutter/core/navigation/startup_screen.dart';
import 'package:test_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:test_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:test_flutter/core/widgets/primary_button.dart';
import 'package:test_flutter/features/home/presentation/screens/home_screen.dart';
import 'package:test_flutter/features/home/presentation/widgets/authenticated_shell.dart';
import "core/navigation/navigation_service.dart";
import 'package:test_flutter/core/auth/token_store.dart';
import 'package:test_flutter/core/api/api_client.dart';
import 'package:test_flutter/features/auth/data/auth_service.dart';
import 'package:test_flutter/features/auth/data/auth_repository_impl.dart';
import 'package:test_flutter/features/auth/domain/auth_repository.dart';
 // For jsonDecode

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
    final themeJson = jsonDecode(themeStr);
    final theme = ThemeDecoder.decodeThemeData(themeJson)!;
    final tokenStore = TokenStore();
    final apiClient = ApiClient(tokenStore);
    final authService = AuthService(apiClient);
    final authRepo = AuthRepositoryImpl(authService, tokenStore);

    final logger = const Logger();

    // Wrap app startup so uncaught errors are logged to console
    FlutterError.onError = (details) {
      logger.error('Flutter error', details.exception, details.stack);
    };

    runApp(
      MultiProvider(
        providers: [
          Provider<TokenStore>.value(value: tokenStore),
          Provider<ApiClient>.value(value: apiClient),
          Provider<AuthService>.value(value: authService),
          Provider<AuthRepository>.value(value: authRepo),
          Provider<Logger>.value(value: logger),
        ],
        child: MyApp(theme: theme),
      ),
    );
  }, (error, stack) {
    // If logger isn't available here, print as fallback
    try {
      const Logger().error('Uncaught zone error', error, stack);
    } catch (_) {
      // ignore: avoid_print
      print('Uncaught zone error: $error\n$stack');
    }
  });
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});


  @override
  Widget build(BuildContext context) {
   return MaterialApp(
    navigatorKey: navigationService.navigatorKey,
    home:const StartupScreen(),
    theme: theme,
    routes: {
      //'/': (context) => MyHomePage(),
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegisterScreen(),
      '/home': (context) => const AuthenticatedShell(),
    },
  );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
