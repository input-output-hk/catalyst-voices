import 'package:catalyst_voices/app/app.dart';
import 'package:flutter/widgets.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../all_test.dart';

extension PatrolTesterExt on PatrolTester {
  Future<void> pumpApp({
    RouterConfig<Object>? routerConfig,
  }) async {
    await pumpWidgetAndSettle(App(routerConfig: routerConfig ?? testsRouter));
    // Gives times for splash to be removed
    await pumpAndTrySettle();
  }
}
