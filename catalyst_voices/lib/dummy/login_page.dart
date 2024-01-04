import 'package:catalyst_voices/dummy/dummy.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

abstract class _Constants {
  static const username = 'robot';
  static const password = '1234';
}

final class _LoginPageState extends State<LoginPage> {
  late TextEditingController usernameTextController;
  late TextEditingController passwordTextController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.loginScreenUsernameLabelText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    key: WidgetKeys.passwordTextController,
                    controller: passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l10n.loginScreenPasswordLabelText,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    key: WidgetKeys.loginButton,
                    onPressed: () async => _loginButtonPressed(context),
                    child: Text(l10n.loginScreenLoginButtonText),
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

  Future<void> _loginButtonPressed(BuildContext context) async {
    if (_validateCredentials()) {
      await _navigateToHomeScreen(context);
    } else {
      _showError(context);
    }
  }

  Future<void> _navigateToHomeScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<HomePage>(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        key: WidgetKeys.loginErrorSnackbar,
        content: Text(context.l10n.loginScreenErrorMessage),
      ),
    );
  }

  bool _validateCredentials() {
    final username = usernameTextController.text;
    final password = passwordTextController.text;

    return isUserLoggedIn =
        username == _Constants.username && password == _Constants.password;
  }
}
