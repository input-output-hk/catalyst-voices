import 'dart:convert';
import 'dart:io';

import 'package:catalyst_cardano_example/main.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:webdriver/async_io.dart';

void main() {

  group('Connect wallet', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('Enable wallet', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      late WebDriver driver;
      // late Process chromeDriverProcess;

      // chromeDriverProcess = await Process.start('chromedriver', ['--port=4444', '--url-base=wd/hub']);

      driver = await createDriver(
        uri: Uri.parse('http://localhost:4444/wd/hub/'),
        desired: Capabilities.chrome,
      );

      await _installChromeExtension(driver, '/home/sotatek/IOHK/catalyst-voices/catalyst_voices_packages/catalyst_cardano/catalyst_cardano/example/test/Eternl.crx');
      await driver.get('https://chromewebstore.google.com/detail/eternl/kmhcihpebfmpgmihbkipmjlmmioameka');
      await driver.get('http://localhost:8000/');

      final element = await driver.findElement(const By.xpath('//*[text()="Enable wallet"]'));
      await element.click();

      // await tester.tap(find.widgetWithText(ElevatedButton, 'Enable wallet'));
      // await tester.pumpAndSettle();

      // await driver.quit();
    });
  });
}

Future<void> _installChromeExtension(WebDriver driver, String extensionPath) async {
  var base64Extension = base64.encode(File(extensionPath).readAsBytesSync());
  try {
    await driver.execute(
      'await chrome.runtime.sendMessage("kmhcihpebfmpgmihbkipmjlmmioameka", {type: "LOAD_EXTENSION", id: "$base64Extension"});', []);
  } catch (e) {
    print(e);
  }
}
