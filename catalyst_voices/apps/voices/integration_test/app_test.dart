import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'pageobject/dashboard_page.dart';
import 'pageobject/spaces_drawer_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDownAll(() async {
    // enable to make sure chrome window stays open after test to check console prints or something
    // await Future<void>.delayed(const Duration(minutes: 5));
  });

  group('End to end tests', () {
    testWidgets('Spaces drawer guest menu renders correctly', (tester) async {
      final args =
          await bootstrap(initialLocation: const DiscoveryRoute().location);
      await tester.pumpWidget(App(routerConfig: args.routerConfig));
      // let the application load
      await tester.pump(const Duration(seconds: 8));
      // pump and settle every 100ms to simulate almost production-like FPS
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      // click on locked user shortcut text link
      await tester.tap(DashboardPage.userLockedShortcutBtn.last);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      // open and check spaces drawer
      await tester.tap(DashboardPage.spacesDrawerButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      SpacesDrawerPage.looksAsExpected();

      //iterate thru spaces and check menu buttons are there
      for (final space in Space.values) {
        await tester.tap(SpacesDrawerPage.chooserItem(space));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
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
    // add test visitor > no menu button
    // add test logged user > menu renders correctly
  });
}
