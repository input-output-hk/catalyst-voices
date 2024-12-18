import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/appBar_page.dart';
import 'pageobject/discovery_page.dart';
import 'pageobject/spaces_drawer_page.dart';
import 'utils/selector_utils.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter(initialLocation: const DiscoveryRoute().location);
    await bootstrap(router: router);
  });

  patrolWidgetTest(
      'Spaces drawer - guest - chooser - clicking on icons works correctly',
      (PatrolTester $) async {
    await $.pumpWidgetAndSettle(App(routerConfig: router));
    await $(DiscoveryPage.guestShortcutBtn)
        .tap(settleTimeout: const Duration(seconds: 10));
    await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
    SpacesDrawerPage.looksAsExpected($);

    // iterate thru spaces by clicking on spaces icons directly
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

    await $(SpacesDrawerPage.chooserItem(Space.discovery)).tap();
  });

  patrolWidgetTest(
      'Spaces drawer - guest - chooser - next,previous buttons work correctly',
      (PatrolTester $) async {
    await $.pumpWidgetAndSettle(App(routerConfig: router));
    await $(DiscoveryPage.guestShortcutBtn)
        .tap(settleTimeout: const Duration(seconds: 10));
    await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
    SpacesDrawerPage.looksAsExpected($);

    // iterate thru spaces by clicking next
    for ( var i = 0; i < Space.values.length; i++) {
      await $(SpacesDrawerPage.chooserNextBtn).tap();
      final children = find.descendant(
        of: $(SpacesDrawerPage.guestMenuItems),
        matching: find.byWidgetPredicate((widget) => true),
      );
      expect($(children), findsAtLeast(1));
      SelectorUtils.isEnabled($, $(SpacesDrawerPage.chooserPrevBtn));
    }
    SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserNextBtn));

    // iterate thru spaces by clicking previous
    for ( var i = 0; i < Space.values.length; i++) {
      await $(SpacesDrawerPage.chooserPrevBtn).tap();
      final children = find.descendant(
        of: $(SpacesDrawerPage.guestMenuItems),
        matching: find.byWidgetPredicate((widget) => true),
      );
      expect($(children), findsAtLeast(1));
      SelectorUtils.isEnabled($, $(SpacesDrawerPage.chooserNextBtn));
    }
    SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserPrevBtn));

    await $(SpacesDrawerPage.chooserItem(Space.discovery)).tap();
  }, skip: true,);

  // needs to be skipped as once clicking on user type shortcut button, clicking on other user
  // type does not work and you are stuck with first shortcut clicked app state
  patrolWidgetTest('Spaces drawer - visitor - no drawer button',
      (PatrolTester $) async {
    await $.pumpWidgetAndSettle(App(routerConfig: router));
    await $(DiscoveryPage.visitorShortcutBtn)
        .tap(settleTimeout: const Duration(seconds: 10));
    expect($(AppBarPage.spacesDrawerButton).exists, false);
  }, skip: true,);
}
