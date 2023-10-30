import 'package:catalyst_voices/poc/constants.dart';
import 'package:flutter_test/flutter_test.dart';

final class LoginRobot {
  final WidgetTester widgetTester;

  const LoginRobot({
    required this.widgetTester,
  });

  Future<void> checkInvalidCredentialsMessageIsShown() async {
    final loginErrorSnackbar = find.byKey(WidgetKeys.loginErrorSnackbar);
    expect(loginErrorSnackbar, findsOneWidget);
    await widgetTester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordTextController =
        find.byKey(WidgetKeys.passwordTextController);
    expect(passwordTextController, findsOneWidget);
    await widgetTester.enterText(passwordTextController, password);
    await widgetTester.pump();
  }

  Future<void> enterUsername(String username) async {
    final usernameTextController =
        find.byKey(WidgetKeys.usernameTextController);
    expect(usernameTextController, findsOneWidget);
    await widgetTester.enterText(usernameTextController, username);
    await widgetTester.pump();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(WidgetKeys.loginButton);
    expect(loginButton, findsOneWidget);
    await widgetTester.tap(loginButton);
    await widgetTester.pump();
  }

  void verifyLoginScreenIsShown() {
    final loginScreen = find.byKey(WidgetKeys.loginScreen);
    expect(loginScreen, findsOneWidget);
  }
}
