import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'password_entry_screen.dart';
import 'protected_screen.dart';
import 'secure_storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

final secureStorageService = SecureStorageService();

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/password',
      builder: (context, state) => PasswordEntryScreen(
        then: state.extra as String? ?? '/protected',
      ),
    ),
    GoRoute(
      path: '/protected',
      builder: (context, state) => const ProtectedScreen(),
      redirect: (context, state) async {
        if (!secureStorageService.isAuthenticated) {
          final hasPassword = await secureStorageService.hasPassword();
          if (!hasPassword) {
            return '/';
          }
          return '/password';
        }
        return null;
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Password Protected App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
