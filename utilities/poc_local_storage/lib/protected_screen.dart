import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_service.dart';

class ProtectedScreen extends StatefulWidget {
  const ProtectedScreen({super.key});

  @override
  State<ProtectedScreen> createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _logout();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Protected Screen'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to the protected screen!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('Logout'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() {
    _authService.logout();
    if (mounted) {
      context.go('/');
    }
  }

  Future<void> _resetPassword() async {
    await _authService.deletePassword();
    if (mounted) {
      context.go('/');
    }
  }
}
