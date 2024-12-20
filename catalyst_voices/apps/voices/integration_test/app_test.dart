import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/app_bar_page.dart';
import 'pageobject/overall_spaces_page.dart';
import 'pageobject/spaces_drawer_page.dart';
import 'utils/selector_utils.dart';

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
    'Spaces drawer - visitor - no drawer button',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.visitorShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      expect($(AppBarPage.spacesDrawerButton).exists, false);
    },
  );

  patrolWidgetTest(
    'Spaces drawer - guest - chooser - clicking on icons works correctly',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.guestShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
      SpacesDrawerPage.guestLooksAsExpected($);

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
    },
  );

  patrolWidgetTest(
    'Spaces drawer - guest - chooser - next,previous buttons work correctly',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.guestShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();

      // iterate thru spaces by clicking next
      for (var i = 0; i < Space.values.length; i++) {
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
      for (var i = 0; i < Space.values.length; i++) {
        await $(SpacesDrawerPage.chooserPrevBtn).tap();
        final children = find.descendant(
          of: $(SpacesDrawerPage.guestMenuItems),
          matching: find.byWidgetPredicate((widget) => true),
        );
        expect($(children), findsAtLeast(1));
        SelectorUtils.isEnabled($, $(SpacesDrawerPage.chooserNextBtn));
      }
      SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserPrevBtn));
    },
  );

  patrolWidgetTest(
    'Spaces drawer - user - chooser - clicking on icons works correctly',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.userShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
      await SpacesDrawerPage.userLooksAsExpected($);
    },
  );

  patrolWidgetTest(
    'Spaces drawer - guest - chooser - all spaces button works',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.guestShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
      await $(SpacesDrawerPage.allSpacesBtn).tap();
      expect($(OverallSpacesPage.spacesListView), findsOneWidget);
    },
  );

  patrolWidgetTest(
    'Spaces drawer - user - chooser - all spaces button works',
    (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.userShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
      await $(SpacesDrawerPage.allSpacesBtn).tap();
      expect($(OverallSpacesPage.spacesListView), findsOneWidget);
    },
  );
}
