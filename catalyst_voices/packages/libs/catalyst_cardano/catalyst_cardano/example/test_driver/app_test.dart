import 'package:catalyst_voices_driver/catalyst_voices_driver.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:webdriver/async_io.dart';

/// To run test driver you need to have chromedriver installed
///
/// Then in terminal run:
/// ```sh
/// chromedriver --port=4444
/// ```
///
/// In new terminal in example dir run:
/// ```sh
///  flutter drive --target=test_driver/app.dart \
/// --web-browser-flag=--disable-web-security \
/// --web-browser-flag=--disable-gpu \
/// --web-browser-flag=--disable-search-engine-choice-screen \
/// --web-header=Cross-Origin-Opener-Policy=same-origin \
/// --web-header=Cross-Origin-Embedder-Policy=require-corp \
/// --debug \
/// --no-headless \
/// -d web-server --browser-name=chrome --driver-port=4444
/// ```
void main() {
  group('Test if extensions are installed and driver can communicate with them',
      () {
    late final VoicesWebDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await VoicesWebDriver.create(extensions);
      // Here should be call function to setup wallets
      await driver.switchToWindow('localhost');
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      await driver.webDriver.quit();
      await driver.close();
    });

    test(
      'Try to enable eternl wallet. Eternl wallet is not configured.',
      () async {
        final buttonFinder = find.byValueKey('enableWallet-eternl');
        await driver.tap(buttonFinder);
        await Future<void>.delayed(const Duration(seconds: 6));
        final currentWindow = await driver.webDriver.window;

        await driver.switchToWindow(extensions[0].id);

        final cancelButtonFinder =
            await driver.webDriver.findElement(const By.tagName('button'));

        await cancelButtonFinder.click();
        await currentWindow.setAsActive();
        find.text('WalletApiException');
      },
      skip: true,
    );
  });
}
