import 'dart:io';
import 'package:webdriver/async_io.dart';

void main() async {
  const extensionPath = '../integration_test/extension-wallet';

  final chromedriver = await Process.start('chromedriver', []);

  await Future.delayed(const Duration(seconds: 2));

  final options = {
    'args': ['--load-extension=$extensionPath']
  };

  final driver = await createDriver(
    uri: Uri.parse('http://localhost:9515'),
    desired: {
      'browserName': 'chrome',
      'goog:chromeOptions': options,
    },
  );
  await driver.get('https://www.google.co.uk/');
  // await driver.get('http://localhost:8000');
  await Future.delayed(const Duration(seconds: 10));

  // final element = await driver.findElement(const By.xpath('//*[text()="Enable wallet"]'));
  // await element.click();

  await Future.delayed(const Duration(seconds: 30));

  // await driver.quit();
  // await chromedriver.kill();
}
