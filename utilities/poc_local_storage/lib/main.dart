import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';

import 'auth_service.dart';
import 'home_screen.dart';
import 'password_entry_screen.dart';
import 'protected_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

final authService = AuthService();

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
        if (!authService.isAuthenticated) {
          // Check if a password is set
          bool hasPassword = await authService.hasPassword();
          if (!hasPassword) {
            return '/'; // Redirect to home if no password is set
          }
          return '/password'; // Redirect to password screen if not authenticated
        }
        return null; // Allow access to protected screen if authenticated
      },
    ),
  ],
  redirect: (context, state) {
    if (state.matchedLocation != '/protected' && authService.isAuthenticated) {
      authService.logout();
    }
    return null;
  },
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
