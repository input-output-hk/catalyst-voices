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

  patrolWidgetTest('Spaces drawer guest menu renders correctly',
      (tester) async {
    final args =
        await bootstrap(initialLocation: const DiscoveryRoute().location);
    await tester.pumpWidgetAndSettle(App(routerConfig: args.routerConfig));
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
