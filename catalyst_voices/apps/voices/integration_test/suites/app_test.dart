import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../all_test.dart';
import '../pageobject/app_bar_page.dart';
import '../pageobject/overall_spaces_page.dart';
import '../pageobject/spaces_drawer_page.dart';
import '../utils/test_utils.dart';

void main() {
  setUp(() {
    testsRouter.go(const DiscoveryRoute().location);
  });

  // Add a simple first test that just verifies setup
  patrolWidgetTest('SETUP - app initializes correctly', (PatrolTester $) async {
    await $.pumpApp();

    // Just verify the app starts and is in visitor state
    expect(find.byType(App), findsOneWidget);

    await AppBarPage($).visitorBtnIsVisible();
    await AppBarPage($).getStartedBtnIsVisible();
  });

  group(
    'Spaces drawer -',
    () {
      patrolWidgetTest(
        'visitor - no drawer button',
        ($) async {
          await $.pumpApp();
          await AppBarPage($).spacesDrawerButtonExists();
        },
      );

      patrolWidgetTest(
        'user - chooser - clicking on icons works correctly',
        skip: true,
        ($) async {
          final account = await TestAccounts.dummyAccount();
          final spaces = [Space.discovery, Space.workspace];

          await TestStateUtils.switchToAccount(account);
          await $.pumpApp();

          await AppBarPage($).spacesDrawerButtonClick();
          SpacesDrawerPage.commonElementsLookAsExpected($);
          for (final space in spaces) {
            await $(SpacesDrawerPage.chooserItem(space)).tap();
            await SpacesDrawerPage.userLooksAsExpected($, space);
          }
        },
      );

      patrolWidgetTest(
        skip: true,
        'guest - chooser - all spaces button works',
        ($) async {
          await $.pumpApp();
          await $(OverallSpacesPage.guestShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          await $(SpacesDrawerPage.allSpacesBtn).tap();
          expect($(OverallSpacesPage.spacesListView), findsOneWidget);
        },
      );

      patrolWidgetTest(
        'user - chooser - all spaces button works',
        skip: true,
        ($) async {
          final account = await TestAccounts.dummyAccount();
          await TestStateUtils.switchToAccount(account);

          await $.pumpApp();
          await $(OverallSpacesPage.userShortcutBtn).tap(settleTimeout: Time.long.duration);
          await AppBarPage($).spacesDrawerButtonClick();
          await $(SpacesDrawerPage.allSpacesBtn).tap();
          expect($(OverallSpacesPage.spacesListView), findsOneWidget);
        },
      );

      patrolWidgetTest(
        'user - chooser - check tooltip text',
        skip: true,
        (PatrolTester $) async {
          final account = await TestAccounts.dummyAccount();
          await TestStateUtils.switchToAccount(account);

          final spaceToTooltipText = <Space, String>{
            Space.discovery: 'Discovery space',
            Space.workspace: 'Workspace',
            Space.voting: 'Voting space',
            Space.fundedProjects: 'Funded project space',
            Space.treasury: 'Treasury space',
          };
          await $.pumpApp();
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
  );
}
