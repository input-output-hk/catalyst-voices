library spaces_drawer_page;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class SpacesDrawerPage {
  static final closeBtn = find.byKey(const Key('MenuCloseButton'));
  static final guestMenuItems = find.byKey(const Key('GuestMenuItems'));
  static final allSpacesBtn =
      find.byKey(const Key('DrawerChooserAllSpacesButton'));
  static final chooserPrevBtn =
      find.byKey(const Key('DrawerChooserPreviousButton'));
  static final chooserNextBtn =
      find.byKey(const Key('DrawerChooserNextButton'));
  static final chooserItemContainer =
      find.byKey(const Key('DrawerChooserItem'));

  static Finder Function(Space space) get chooserItem => (Space space) {
        return find.byKey(Key('DrawerChooser$space'));
      };

  static Finder Function(Space name) get chooserIcon => (Space space) {
        return find.byKey(Key('DrawerChooser${space}AvatarKey'));
      };

  static void Function() get looksAsExpected => () {
        expect(closeBtn, findsOneWidget);
        expect(allSpacesBtn, findsOneWidget);
        expect(chooserPrevBtn, findsOneWidget);
        expect(chooserNextBtn, findsOneWidget);
        expect(chooserItemContainer, findsExactly(5));
        expect(
          chooserIcon(Space.discovery),
          findsOneWidget,
        );
      };
}
