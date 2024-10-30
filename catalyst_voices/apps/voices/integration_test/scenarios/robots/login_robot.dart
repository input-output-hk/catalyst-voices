import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/login/login_email_text_filed.dart';
import 'package:catalyst_voices/pages/login/login_password_text_field.dart';
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
    final emailTextField = find.byKey(LoginEmailTextFiled.emailInputKey);
    expect(emailTextField, findsOneWidget);
    await widgetTester.enterText(emailTextField, email);
    await widgetTester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordTextField = find.byKey(
      LoginPasswordTextField.passwordInputKey,
    );
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
