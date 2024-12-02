import 'package:catalyst_voices_driver/catalyst_voices_driver.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:webdriver/async_io.dart';

void main() {
  group('Test if extensions are installed and driver can communicate with them',
      () {
    late final VoicesWebDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await VoicesWebDriver.create(extensions);
      // Here should be call function to setup wallets
      await switchToWindowContaining(driver.webDriver, 'localhost');
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

        await switchToWindowContaining(driver.webDriver, extensions[0].id);

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

Future<void> switchToWindowContaining(
  WebDriver driver,
  String urlPattern,
) async {
  final windows = await driver.windows.toList();
  for (final window in windows) {
    await driver.switchTo.window(window);
    final url = await driver.currentUrl;
    if (url.contains(urlPattern)) {
      break;
    }
  }
}
