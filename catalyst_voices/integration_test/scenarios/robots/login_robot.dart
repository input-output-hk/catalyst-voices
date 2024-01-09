import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final class LoginRobot {
  final WidgetTester widgetTester;

  const LoginRobot({
    required this.widgetTester,
  });

  Future<void> checkInvalidCredentialsMessageIsShown() async {
    final loginErrorSnackbar = find.byKey(LoginForm.loginErrorSnackbarKey);
    expect(loginErrorSnackbar, findsOneWidget);
    await widgetTester.pump();
  }

  Future<void> enterEmail(String email) async {
    final emailTextField = find.byKey(EmailInput.emailInputKey);
    expect(emailTextField, findsOneWidget);
    await widgetTester.enterText(emailTextField, email);
    await widgetTester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordTextField = find.byKey(PasswordInput.passwordInputKey);
    expect(passwordTextField, findsOneWidget);
    await widgetTester.enterText(passwordTextField, password);
    await widgetTester.pump();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(LoginInButton.loginButtonKey);
    expect(loginButton, findsOneWidget);
    await widgetTester.tap(loginButton);
    await widgetTester.pump();
  }

  void verifyLoginScreenIsShown() {
    final loginScreen = find.byKey(LoginForm.loginFormKey);
    expect(loginScreen, findsOneWidget);
  }
}
