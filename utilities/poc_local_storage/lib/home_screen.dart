// ignore_for_file: discarded_futures

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poc_local_storage/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                onPressed: () => _navigateToPasswordScreen(context),
                child: const Text('Go to Protected Screen'),
              )
            : ElevatedButton(
                onPressed: () async => _showCreatePasswordDialog(context),
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
    final hasPassword = await certificateRepo.hasPassword;
    setState(() {
      _hasPassword = hasPassword;
    });
  }

  void _navigateToPasswordScreen(BuildContext context) {
    context.go('/password');
  }

  Future<void> _showCreatePasswordDialog(BuildContext context) {
    var tempPassword = '';
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) => tempPassword = value,
            decoration: const InputDecoration(
              hintText: 'Enter your new password',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop();
                await certificateRepo.setPassword(tempPassword);
                tempPassword = '';
                await _checkPassword();
              },
            ),
          ],
        );
      },
    );
  }
}
