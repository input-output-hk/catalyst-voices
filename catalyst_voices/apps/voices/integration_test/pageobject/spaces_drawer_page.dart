import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

class SpacesDrawerPage {
  static const closeBtn = Key('MenuCloseButton');
  static const guestMenuItems = Key('GuestMenuItems');
  static const allSpacesBtn = Key('DrawerChooserAllSpacesButton');
  static const chooserPrevBtn = Key('DrawerChooserPreviousButton');
  static const chooserNextBtn = Key('DrawerChooserNextButton');
  static const chooserItemContainer = Key('DrawerChooserItem');
  static const userDiscoveryDashboardTile = Key('DiscoveryDashboardTile');
  static const userRolesTile = Key('RolesTile');
  static const userFeedbackTile = Key('FeedbackTile');
  static const userDocumentationTile = Key('DocumentationTile');
  static const userDrawerMenuItem = Key('UserDrawerMenuItem');
  static const tooltipElement = Key('Tooltip');

  static Key chooserIcon(Space space) {
    return Key('DrawerChooser${space}AvatarKey');
  }

  static Key chooserItem(Space space) {
    return Key('DrawerChooser$space');
  }

  static void commonElementsLookAsExpected(PatrolTester $) {
    expect($(closeBtn), findsOneWidget);
    expect($(allSpacesBtn), findsOneWidget);
    expect($(chooserPrevBtn), findsOneWidget);
    expect($(chooserNextBtn), findsOneWidget);
    expect($(chooserItemContainer), findsExactly(5));
  }

  static Future<void> guestLooksAsExpected(PatrolTester $, Space space) async {
    expect(
      $(SpacesDrawerPage.chooserIcon(space)),
      findsOneWidget,
    );
    final children = find.descendant(
      of: $(guestMenuItems),
      matching: find.byWidgetPredicate((widget) => true),
    );
    expect($(children), findsAtLeast(1));
  }

  static void userDiscoveryLooksAsExpected(PatrolTester $) {
    expect(
      $(userMenuContainer(Space.discovery)).$(userHeader(Space.discovery)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.discovery)).$(userDiscoveryDashboardTile),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.discovery)).$(userRolesTile),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.discovery)).$(userFeedbackTile),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.discovery)).$(userDocumentationTile),
      findsOneWidget,
    );
  }

  static void userFundedProjectsLooksAsExpected(PatrolTester $) {
    expect(
      $(userMenuContainer(Space.fundedProjects)),
      findsOneWidget,
    );
  }

  static Key userHeader(Space space) {
    return Key('SpaceHeader.${space.name}');
  }

  static Future<void> userLooksAsExpected(PatrolTester $, Space space) async {
    switch (space) {
      case Space.discovery:
        userDiscoveryLooksAsExpected($);
        break;
      case Space.workspace:
        userWorkspaceLooksAsExpected($);
        break;
      case Space.voting:
        userVotingLooksAsExpected($);
        break;
      case Space.fundedProjects:
        userFundedProjectsLooksAsExpected($);
        break;
      case Space.treasury:
        userTreasuryLooksAsExpected($);
        break;
    }
  }

  static Key userMenuContainer(Space space) {
    return Key('Drawer${space}MenuKey');
  }

  static Key userSectionHeader(Space space) {
    return Key('Header.${space.name}');
  }

  static void userTreasuryLooksAsExpected(PatrolTester $) {
    expect(
      $(userMenuContainer(Space.treasury)).$(userHeader(Space.treasury)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.treasury)).$(userSectionHeader(Space.treasury)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.treasury)).$(userDrawerMenuItem),
      findsAtLeast(1),
    );
  }

  static void userVotingLooksAsExpected(PatrolTester $) {
    expect(
      $(userMenuContainer(Space.voting)).$(userHeader(Space.voting)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.voting)).$(userSectionHeader(Space.voting)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.voting)).$(userDrawerMenuItem),
      findsAtLeast(1),
    );
  }

  static void userWorkspaceLooksAsExpected(PatrolTester $) {
    expect(
      $(userMenuContainer(Space.workspace)).$(userHeader(Space.workspace)),
      findsOneWidget,
    );
    expect(
      $(userMenuContainer(Space.workspace))
          .$(userSectionHeader(Space.workspace)),
      findsOneWidget,
    );
  }
}
