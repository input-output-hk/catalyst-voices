import 'package:catalyst_voices/dummy/poc.dart';
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
  static const loginButtonText = 'Login';
}

final class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameTextController;
  late TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.loginScreen,
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    key: WidgetKeys.usernameTextController,
                    controller: usernameTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: _Constants.usernameLabelText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    key: WidgetKeys.passwordTextController,
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: _Constants.passwordLabelText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    key: WidgetKeys.loginButton,
                    onPressed: () => _loginButtonPressed(context),
                    child: const Text(_Constants.loginButtonText),
                  ),
                ),
              ],
            ),
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

  void _loginButtonPressed(BuildContext context) {
    if (_validateCredentials()) {
      _navigateToHomeScreen(context);
    } else {
      _showError(context);
    }
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<HomeScreen>(
        builder: (context) => const HomeScreen(),
      ),
    );
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
