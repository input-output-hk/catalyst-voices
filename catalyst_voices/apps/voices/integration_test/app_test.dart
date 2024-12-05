import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End to end tests', () {
    testWidgets('Spaces drawer guest menu renders correctly', (tester) async {
      final args =
          await bootstrap(initialLocation: const DiscoveryRoute().location);
      await tester.pumpWidget(App(routerConfig: args.routerConfig));
      // let the application load
      await tester.pump(const Duration(seconds: 5));
      // pump and settle every 100ms to simulate almost production-like FPS
      await tester.pumpAndSettle(const Duration(milliseconds: 100));

      await tester.tap(find.textContaining('No key (visitor)'));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      await tester.tap(find.byKey(const Key('drawer_button')));
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      // spaces drawer is opened
      expect(find.byKey(const Key('SpacesMenuCloseButton')), findsOneWidget);

      //ToDo 1. check spaces chooser looks
      expect(find.byKey(const Key('DrawerSpaceChooserAllSpacesButton')),
          findsOneWidget);
      expect(find.byKey(const Key('DrawerSpaceChooserPreviousButton')),
          findsOneWidget);
      expect(find.byKey(const Key('DrawerSpaceChooserNextButton')),
          findsOneWidget);
      expect(find.byKey(const Key('DrawerSpaceChooserItem')), findsExactly(5));
      expect(find.byKey(const Key('DrawerChooserSpace.discoveryAvatarKey')),
          findsOneWidget);

      //ToDo 2. iterate thru spaces and check sections buttons are there
      final spacesNames = <String>[
        'discovery',
        'workspace',
        'voting',
        'fundedProjects',
        'treasury',
      ];

      for (final name in spacesNames) {
        await tester.tap(find.byKey(Key('DrawerSpaceChooserSpace.$name')));
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
        final children = find.descendant(of: find.byKey(const Key('GuestMenuItems')), matching: find.byWidgetPredicate((widget) => true));
        expect(children, findsAtLeast(1));
      }
      // await Future<void>.delayed(const Duration(minutes: 5));
    });
    // test visitor > no menu button
    // test user ? menu renders correctly
  });
}
