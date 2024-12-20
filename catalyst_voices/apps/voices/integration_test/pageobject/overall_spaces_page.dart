library dashboard_page;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class OverallSpacesPage {
  static const guestShortcutBtn = Key('GuestShortcut');
  static const visitorShortcutBtn = Key('VisitorShortcut');
  static const userShortcutBtn = Key('UserShortcut');
  static const spacesListView = Key('SpacesListView');

  static Key spaceOverview(Space space) {
    return Key('SpaceOverview.${space.name}');
  }
}
