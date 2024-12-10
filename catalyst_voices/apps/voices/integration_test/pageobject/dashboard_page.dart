library dashboard_page;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DashboardPage {
  static final userLockedShortcutBtn = find.byKey(const Key('ToggleStateText'));
  static final spacesDrawerButton = find.byKey(const Key('DrawerButton'));
}
