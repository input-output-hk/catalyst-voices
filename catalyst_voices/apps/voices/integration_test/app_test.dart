import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/dashboard_page.dart';
import 'pageobject/spaces_drawer_page.dart';
import 'utils/selector_utils.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter(initialLocation: const DiscoveryRoute().location);
    await bootstrap(router: router);
  });

  patrolWidgetTest('Spaces drawer guest menu renders correctly',
      (PatrolTester $) async {
    await $.pumpWidgetAndSettle(App(routerConfig: router));
    await $(DashboardPage.guestShortcutBtn)
        .first
        .tap(settleTimeout: const Duration(seconds: 10));
    await $(DashboardPage.spacesDrawerButton).waitUntilVisible().tap();
    SpacesDrawerPage.looksAsExpected($);

    // iterate thru spaces and check menu buttons are there
    for (final space in Space.values) {
      await $(SpacesDrawerPage.chooserItem(space)).tap();
      expect(
        $(SpacesDrawerPage.chooserIcon(space)),
        findsOneWidget,
      );
      final children = find.descendant(
        of: $(SpacesDrawerPage.guestMenuItems),
        matching: find.byWidgetPredicate((widget) => true),
      );
      expect($(children), findsAtLeast(1));
    }
    SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserNextBtn));
    // await $(SpacesDrawerPage.chooserItem(Space.discovery)).tap();
  });

  patrolWidgetTest('Spaces drawer guest menu renders correctly 2',
      (PatrolTester $) async {
    await $.pumpWidgetAndSettle(App(routerConfig: router));
    await $(DashboardPage.guestShortcutBtn)
        .first
        .tap(settleTimeout: const Duration(seconds: 10));
    await $(DashboardPage.spacesDrawerButton).waitUntilVisible().tap();
    SpacesDrawerPage.looksAsExpected($);

    // iterate thru spaces and check menu buttons are there
    for (final space in Space.values) {
      await $(SpacesDrawerPage.chooserItem(space)).tap();
      expect(
        $(SpacesDrawerPage.chooserIcon(space)),
        findsOneWidget,
      );
      final children = find.descendant(
        of: $(SpacesDrawerPage.guestMenuItems),
        matching: find.byWidgetPredicate((widget) => true),
      );
      expect($(children), findsAtLeast(1));
    }
    SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserNextBtn));
    // await $(SpacesDrawerPage.chooserItem(Space.discovery)).tap();
  });
}
