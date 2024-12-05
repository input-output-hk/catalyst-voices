library DashboardPage;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class DashboardPage {
  static final userLockedBtn = find.byKey(const Key('toggleStateText'));
  static final drawerButton = find.byKey(const Key('drawer_button'));
}
