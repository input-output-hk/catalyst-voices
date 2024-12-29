import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/app_bar_page.dart';
import 'pageobject/onboarding_page.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
    await bootstrap(router: router);
  });

  setUp(() async {
    await registerDependencies();
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  patrolWidgetTest(
    'Onboarding - visitor - get started button works',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      expect($(OnboardingPage.registrationInfoPanel), findsOneWidget);
      expect($(OnboardingPage.registrationDetailsPanel), findsOneWidget);
    },
  );

  patrolWidgetTest(
    'Onboarding - visitor - get started screen looks as expected',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await OnboardingPage.getStartedScreenLooksAsExpected($);
    },
  );
}
