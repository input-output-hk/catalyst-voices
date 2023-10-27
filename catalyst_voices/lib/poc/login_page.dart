import 'package:catalyst_voices/poc/poc.dart';
import 'package:flutter/material.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

abstract class _Constants {
  static const usernameLabelText = 'Username';
  static const passwordLabelText = 'Password';
  static const username = 'robot';
  static const password = '1234';
  static const errorMessage = 'Wrong credentials';
}

final class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameTextController;
  late TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.loginScreen,
      body: Center(
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: WidgetKeys.usernameTextController,
                controller: usernameTextController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: _Constants.usernameLabelText,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                key: WidgetKeys.passwordTextController,
                controller: passwordTextController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: _Constants.passwordLabelText,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                key: WidgetKeys.loginButton,
                onPressed: () {
                  if (_validateCredentials()) {
                    _navigateToHomeScreen(context);
                  } else {
                    _showError(context);
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.of(context).pushNamed('/home-page');
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        key: WidgetKeys.loginErrorSnackbar,
        content: Text(_Constants.errorMessage),
      ),
    );
  }

  bool _validateCredentials() {
    final username = usernameTextController.text;
    final password = passwordTextController.text;
    return username == _Constants.username && password == _Constants.password;
  }
}
