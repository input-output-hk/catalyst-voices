import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'pageobject/dashboard_page.dart';
import 'pageobject/spaces_drawer_page.dart';
import 'types/types.dart';

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

      await tester.tap(DashboardPage.userLockedBtn.last);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.tap(DashboardPage.drawerButton);
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      // spaces drawer is opened
      expect(SpacesDrawerPage.closeBtn, findsOneWidget);

      //ToDo 1. check spaces chooser looks
      expect(SpacesDrawerPage.allSpacesBtn, findsOneWidget);
      expect(SpacesDrawerPage.chooserPrevBtn, findsOneWidget);
      expect(SpacesDrawerPage.chooserNextBtn, findsOneWidget);
      expect(SpacesDrawerPage.chooserItemContainer, findsExactly(5));
      expect(
        SpacesDrawerPage.chooserIcon(Space.discovery),
        findsOneWidget,
      );

      //ToDo 2. iterate thru spaces and check sections buttons are there
      for (final space in Space.values) {
        await tester.tap(SpacesDrawerPage.chooserItem(space));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final children = find.descendant(
          of: SpacesDrawerPage.guestMenuItems,
          matching: find.byWidgetPredicate((widget) => true),
        );
        expect(children, findsAtLeast(1));
      }
    });
    // test visitor > no menu button
    // test user ? menu renders correctly
  });
}
