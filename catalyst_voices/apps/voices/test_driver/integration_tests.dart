import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

// TODO(damian-molinski): install chrome extensions https://github.com/input-output-hk/catalyst-voices/issues/3204
// TODO(damian-molinski): driver hangs after all tests completed on macOS https://github.com/input-output-hk/catalyst-voices/issues/3205
Future<void> main() async {
  final driver = await FlutterDriver.connect(
    timeout: const Duration(minutes: 10),
    printCommunication: true,
  );
  await integrationDriver(
    driver: driver,
    writeResponseOnFailure: true,
  );
}
