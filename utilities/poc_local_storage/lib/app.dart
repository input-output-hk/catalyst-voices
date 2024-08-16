import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_local_storage/home_screen.dart';
import 'package:poc_local_storage/main.dart';
import 'package:poc_local_storage/password_entry_screen.dart';
import 'package:poc_local_storage/protected_screen.dart';

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
        if (!certificateRepo.isAuthenticated) {
          final hasPassword = await certificateRepo.hasPassword;
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

class App extends StatelessWidget {
  const App({super.key});

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
