import 'package:catalyst_voices/configs/main_dev.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  LoginRobot loginRobot;

  group('Login', () {
    testWidgets('shows error message when login information is missing',
        (tester) async {
      loginRobot = await _configure(tester);

      await loginRobot.enterUsername('Not Valid');
      await loginRobot.tapLoginButton();
      await loginRobot.checkInvalidCredentialsMessageIsShown();
    });

    testWidgets('authenticates a user with an username and password',
        (tester) async {
      loginRobot = await _configure(tester);

      await loginRobot.enterUsername('robot');
      await loginRobot.enterPassword('1234');
      await loginRobot.tapLoginButton();
    });
  });
}

Future<LoginRobot> _configure(WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
  return LoginRobot(widgetTester: tester);
}
