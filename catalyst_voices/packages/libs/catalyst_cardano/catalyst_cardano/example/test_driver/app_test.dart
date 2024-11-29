import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

// import 'package:webdriver/sync_core.dart';

import '../custom_test_driver/flutter_web_driver.dart';

void main() {
  group('Hello World App', () {
    late WebFlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await createVoicesWebDriver();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.webDriver.quit();
      await driver.close();
      // await driver.close();
    });

    test(
      'test name',
      () async {
        // final buttonFinder = find.byType('ElevatedButton');
        // // final windows = await driver.webDriver.windows.toList();
        // var windows = await driver.webDriver.windows.toList();
        // await driver.tap(buttonFinder);
        // await Future<void>.delayed(const Duration(seconds: 6));
        // final currentWindow = await driver.webDriver.window;

        // // Switch to popup window if needed
        // windows = await driver.webDriver.windows.toList();
        // for (final window in windows) {
        //   await driver.webDriver.switchTo.window(window);
        //   final url = await driver.webDriver.currentUrl;
        //   if (url.contains('enable.html?id=')) {
        //     // Found extension popup
        //     print('Found extension window: $url');
        //     print('Found window id: ${window.id}');

        //     await Future<void>.delayed(const Duration(seconds: 2));
        //     break;
        //   }
        // }

        // final cancelButtonFinder =
        //     await driver.webDriver.findElement(const By.tagName('button'));
        // print('Found cancelButtonFinder : $cancelButtonFinder');
        // final win1 = await driver.webDriver.window;

        // await cancelButtonFinder.click();
        // // await driver.webDriver.switchTo.window(currentWindow);
        // await currentWindow.setAsActive();
        // final win = await driver.webDriver.window;
        // print('currentWindow back : ${win.id}');
        // await find.text('WalletApiException');
      },
      timeout: const Timeout(Duration(seconds: 60)),
    );
  });
}
