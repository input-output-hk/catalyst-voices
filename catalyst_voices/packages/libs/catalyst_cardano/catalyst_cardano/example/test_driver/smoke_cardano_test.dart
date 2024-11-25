import 'package:flutter_driver/flutter_driver.dart' as dr;
import 'package:flutter_test/flutter_test.dart';

import '../custom_test_driver/flutter_web_driver.dart';

// TODO(web): Migrate this test to a normal integration_test with a WidgetTester.

/// The following test is used as a simple smoke test for verifying Flutter
/// Framework and Flutter Web Engine integration.
void main() {
  group('Hello World App', () {
    late dr.WebFlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await createCustomWebDriver();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.close();
    });

    testWidgets('Check if supported extension are displayed', (tester) async {
      await tester.pump(const Duration(seconds: 5));

      expect(find.byType, findsAny);
    });
  });
}
