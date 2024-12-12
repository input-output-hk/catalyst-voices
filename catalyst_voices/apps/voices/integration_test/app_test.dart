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

  tearDownAll(() async {
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
  });
}
//TODO(oldgreg5): add test clicking on prev/next buttons on chooser
//TODO(oldgreg5): add test visitor > no menu button
//TODO(oldgreg5): add test logged user > menu renders correctly

//TODO(oldgreg5): add test reporting (simple summary with errors for starters)
//TODO(oldgreg5): add screenshots capturing
//TODO(oldgreg5): add redirecting output to local console/file instead of chrome console
//TODO(oldgreg5): add running in debug, being able to pause and debug test
