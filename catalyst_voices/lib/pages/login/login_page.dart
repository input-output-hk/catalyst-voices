import 'package:catalyst_voices/pages/login/login.dart';
import 'package:flutter/material.dart';

final class LoginPage extends StatelessWidget {
  static const loginPage = Key('LoginInPage');

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginForm();
  }
}
