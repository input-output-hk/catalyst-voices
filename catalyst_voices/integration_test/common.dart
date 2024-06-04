import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/app/view/app_page.dart';
import 'package:catalyst_voices/configs/main_qa.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

export 'package:flutter_test/flutter_test.dart';
export 'package:patrol/patrol.dart';

const _nativeAutomatorConfig = NativeAutomatorConfig(
  findTimeout: Duration(seconds: 30), // 10 seconds is too short for some CIs
);

Future<void> createApp(PatrolIntegrationTester $) async {
  await app.main();
  await $.pumpWidgetAndSettle(const App());
}

void patrol(
  String description,
  Future<void> Function(PatrolIntegrationTester) callback, {
  bool? skip,
  NativeAutomatorConfig? nativeAutomatorConfig,
  LiveTestWidgetsFlutterBindingFramePolicy framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fadePointers,
}) {
  patrolTest(
    description,
    nativeAutomatorConfig: nativeAutomatorConfig ?? _nativeAutomatorConfig,
    framePolicy: framePolicy,
    skip: skip,
    callback,
  );
}
