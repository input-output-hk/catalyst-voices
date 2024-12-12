import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'pageobject/dashboard_page.dart';
import 'pageobject/spaces_drawer_page.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // var args = bootstrap(initialLocation: const DiscoveryRoute().location);
  try {
    // final logFile = File('test_output.log')
    // ..openWrite(); //throws Error:Unsupported operation:_Namespace
    // final logSink = logFile.openWrite();
  } catch (e, stack) {
    print('Error: $e');
    print('Stack: $stack');
  }

  // debugPrint = (String? message, {int? wrapWidth}) {
  //   logSink.writeln(message);
  //   logSink.flush(); // Ensure the log is written
  // };

  setUp(() async {
    // args =
    // await bootstrap(initialLocation: const DiscoveryRoute().location);
    // This is required prior to taking the screenshot (Android only).
    // await binding.convertFlutterSurfaceToImage();
  });

  tearDownAll(() async {
    // await logSink.close(); // Ensure logs are written to the file
    // enable to make sure chrome window stays open after test to check console prints or something
    // await Future<void>.delayed(const Duration(minutes: 5));
  });

  // group('End to end tests', () {
  patrolWidgetTest('Spaces drawer guest menu renders correctly',
      (tester) async {
    final args =
        await bootstrap(initialLocation: const DiscoveryRoute().location);
    await tester.pumpWidgetAndSettle(App(routerConfig: args.routerConfig));
    print('App loaded');
    await tester(DashboardPage.guestShortcutBtn.first).tap();
    await tester(DashboardPage.spacesDrawerButton).tap();
    SpacesDrawerPage.looksAsExpected();

    //iterate thru spaces and check menu buttons are there
    for (final space in Space.values) {
      await tester(SpacesDrawerPage.chooserItem(space)).tap();
      expect(
        SpacesDrawerPage.chooserIcon(space),
        findsOneWidget,
      );
      final children = find.descendant(
        of: SpacesDrawerPage.guestMenuItems,
        matching: find.byWidgetPredicate((widget) => true),
      );
      expect(children, findsAtLeast(1));
    }
  });
}
