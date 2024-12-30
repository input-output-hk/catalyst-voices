import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/app_bar_page.dart';
import 'pageobject/overall_spaces_page.dart';
import 'pageobject/spaces_drawer_page.dart';
import 'utils/selector_utils.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies();
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  group(
    'Spaces drawer -',
    () {
      patrolWidgetTest(
        'visitor - no drawer button',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.visitorShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          expect($(AppBarPage.spacesDrawerButton).exists, false);
        },
      );

      patrolWidgetTest(
        'guest - chooser - clicking on icons works correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.guestShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
          SpacesDrawerPage.commonElementsLookAsExpected($);

          // iterate thru spaces by clicking on spaces icons directly
          for (final space in Space.values) {
            await $(SpacesDrawerPage.chooserItem(space)).tap();
            await SpacesDrawerPage.guestLooksAsExpected($, space);
          }
          SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserNextBtn));
        },
      );

      patrolWidgetTest(
        'guest - chooser - next,previous buttons work correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.guestShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();

          // iterate thru spaces by clicking next
          for (final space in Space.values) {
            await SpacesDrawerPage.guestLooksAsExpected($, space);
            await $(SpacesDrawerPage.chooserNextBtn).tap();
            SelectorUtils.isEnabled($, $(SpacesDrawerPage.chooserPrevBtn));
          }
          SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserNextBtn));

          // iterate thru spaces by clicking previous
          for (final space in Space.values.reversed) {
            await SpacesDrawerPage.guestLooksAsExpected($, space);
            await $(SpacesDrawerPage.chooserPrevBtn).tap();
            SelectorUtils.isEnabled($, $(SpacesDrawerPage.chooserNextBtn));
          }
          SelectorUtils.isDisabled($, $(SpacesDrawerPage.chooserPrevBtn));
        },
      );

      patrolWidgetTest(
        'user - chooser - clicking on icons works correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.userShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
          SpacesDrawerPage.commonElementsLookAsExpected($);
          for (final space in Space.values) {
            await $(SpacesDrawerPage.chooserItem(space)).tap();
            await SpacesDrawerPage.userLooksAsExpected($, space);
          }
        },
      );

      patrolWidgetTest(
        'guest - chooser - all spaces button works',
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
        'user - chooser - all spaces button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.userShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await $(AppBarPage.spacesDrawerButton).waitUntilVisible().tap();
          await $(SpacesDrawerPage.allSpacesBtn).tap();
          expect($(OverallSpacesPage.spacesListView), findsOneWidget);
        },
      );
    },
  );
}
