library spaces_drawer_page;

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

  static Key chooserItem(Space space) {
    return Key('DrawerChooser$space');
  }

  static Key chooserIcon(Space space) {
    return Key('DrawerChooser${space}AvatarKey');
  }

  static void looksAsExpected(PatrolTester $) {
    expect($(closeBtn), findsOneWidget);
    expect($(allSpacesBtn), findsOneWidget);
    expect($(chooserPrevBtn), findsOneWidget);
    expect($(chooserNextBtn), findsOneWidget);
    expect($(chooserItemContainer), findsExactly(5));
    expect(
      $(chooserIcon(Space.discovery)),
      findsOneWidget,
    );
  }
}
