import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/app_bar_page.dart';
import 'pageobject/onboarding_page.dart';
import 'pageobject/overall_spaces_page.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  group('Onboarding -', () {
    patrolWidgetTest(
      'visitor - get started button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await $(OverallSpacesPage.visitorShortcutBtn)
            .tap(settleTimeout: const Duration(seconds: 10));
        await $(AppBarPage.getStartedBtn).tap();
        expect($(OnboardingPage.registrationInfoPanel), findsOneWidget);
        expect($(OnboardingPage.registrationDetailsPanel), findsOneWidget);
      },
    );

    patrolWidgetTest(
      'visitor - get started screen looks as expected',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await $(AppBarPage.getStartedBtn)
            .tap(settleTimeout: const Duration(seconds: 10));
        await OnboardingPage.getStartedScreenLooksAsExpected($);
      },
    );
  });
}
