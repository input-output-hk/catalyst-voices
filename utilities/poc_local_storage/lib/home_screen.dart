import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'password_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  bool _hasPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _hasPassword
            ? ElevatedButton(
                onPressed: _navigateToProtectedScreen,
                child: const Text('Go to Protected Screen'),
              )
            : ElevatedButton(
                onPressed: () => _showCreatePasswordDialog(context),
                child: const Text('Create Your Password'),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkPassword();
  }

  Future<void> _checkPassword() async {
    final storedPassword = await storage.read(key: 'user_password');
    setState(() {
      _hasPassword = storedPassword != null;
    });
  }

  Future<void> _createPassword(String newPassword) async {
    if (newPassword.isNotEmpty) {
      await storage.write(key: 'user_password', value: newPassword);
      await _checkPassword();
    }
  }

  void _navigateToProtectedScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PasswordEntryScreen()),
    );
  }

  Future<void> _showCreatePasswordDialog(BuildContext context) {
    String tempPassword = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) => tempPassword = value,
            decoration:
                const InputDecoration(hintText: "Enter your new password"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
                _createPassword(tempPassword);
              },
            ),
          ],
        );
      },
    );
  }
}
