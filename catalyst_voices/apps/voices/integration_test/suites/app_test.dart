import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/overall_spaces_page.dart';
import '../pageobject/spaces_drawer_page.dart';
import '../utils/bootstrap_utils.dart';
import '../utils/constants.dart';
import '../utils/selector_utils.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerForTests();
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartForTests();
  });

  group(
    'Spaces drawer -',
    () {
      patrolWidgetTest(
        'visitor - no drawer button',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await AppBarPage($).spacesDrawerButtonExists();
        },
      );

      patrolWidgetTest(
        tags: 'issues_1473',
        skip: true,
        'guest - chooser - clicking on icons works correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.guestShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
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
        tags: 'issues_1473',
        skip: true,
        'guest - chooser - next,previous buttons work correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.guestShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();

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
        tags: 'issues_1715',
        skip: true,
        'user - chooser - clicking on icons works correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.userShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          SpacesDrawerPage.commonElementsLookAsExpected($);
          for (final space in Space.values) {
            await $(SpacesDrawerPage.chooserItem(space)).tap();
            await SpacesDrawerPage.userLooksAsExpected($, space);
          }
        },
      );

      patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'guest - chooser - all spaces button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.guestShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          await $(SpacesDrawerPage.allSpacesBtn).tap();
          expect($(OverallSpacesPage.spacesListView), findsOneWidget);
        },
      );

      patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'user - chooser - all spaces button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.userShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          await $(SpacesDrawerPage.allSpacesBtn).tap();
          expect($(OverallSpacesPage.spacesListView), findsOneWidget);
        },
      );

      patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'user - chooser - check tooltip text',
        (PatrolTester $) async {
          final spaceToTooltipText = <Space, String>{
            Space.discovery: 'Discovery space',
            Space.workspace: 'Workspace',
            Space.voting: 'Voting space',
            Space.fundedProjects: 'Funded project space',
            Space.treasury: 'Treasury space',
          };
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.userShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          for (final space in Space.values) {
            await $(SpacesDrawerPage.chooserItem(space)).tap();
            await $(SpacesDrawerPage.chooserIcon(space)).longPress();
            await Future<void>.delayed(const Duration(seconds: 1));
            final expectedText = spaceToTooltipText[space];
            final chooserItem = find.byKey(SpacesDrawerPage.chooserItem(space));
            final tooltipElement = find.descendant(
              of: chooserItem,
              matching: find.byKey(SpacesDrawerPage.tooltipElement),
            );
            final tooltipTextElement = find.descendant(
              of: tooltipElement,
              matching: find.byType(Text),
            );

            final tooltipText = $(tooltipTextElement).text;
            expect(tooltipText, expectedText);
          }
        },
      );
    },
    skip: true,
  );
}
