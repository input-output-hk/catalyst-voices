import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class FakeLaunchOptions extends Fake implements LaunchOptions {}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // late MockUrlLauncherPlatform mockUrlLauncherPlatform;

  setUpAll(() async {
    // Register a fallback value for LaunchOptions
    // registerFallbackValue(const LaunchOptions());
  });

  setUp(() async {
    // mockUrlLauncherPlatform = MockUrlLauncherPlatform();

    // 1. Set the mock instance as the current platform
    // UrlLauncherPlatform.instance = MockUrlLauncherPlatform();
  });

  patrolWidgetTest(
    'visitor - url mock test',
    (PatrolTester $) async {
      // 2. Define the URL to be launched
      final Uri testUrl = Uri.parse('https://www.example.com');
      final testUrlString = testUrl.toString();
      registerFallbackValue(const LaunchOptions());

      // 3. Override the launchUrl function by using default implementation and set expectations
      await $.tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Launch the URL via the url_launcher package
                  final canLaunch = await canLaunchUrl(testUrl);
                  if (canLaunch) {
                    await launchUrl(testUrl);
                  }
                },
                child: const Text('Launch URL'),
              ),
            ),
          ),
        ),
      );

      // 4. Define the mock behavior BEFORE tapping the button
      // mockito
      // when(
      //   mockUrlLauncherPlatform.launchUrl(
      //     testUrlString,
      //     any,
      //   ),
      // ) // Use testUrl (String)
      //     .thenAnswer((_) async => true);
// mocktail
//       when(() => mockUrlLauncherPlatform.launchUrl(testUrlString, any()))
//           .thenAnswer((_) async => true);
      // print('^^^.Mock set');

      // 5. Find and tap the button
      await $.tester.tap(find.text('Launch URL'));
      print('^^^.Tapped');
      await $.tester.pumpAndSettle();

      // 6. Verify that the mock launchUrl function was called with the expected URL
      //mockito
      // verify(
      //   mockUrlLauncherPlatform.launchUrl(
      //     testUrlString,
      //     const LaunchOptions(),
      //   ),
      // ).called(1);

      // mocktail
      // verify(() => mockUrlLauncherPlatform.launchUrl(testUrlString, any()))
      //     .called(1);
    },
  );
}
