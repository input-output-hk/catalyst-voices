import 'dart:io';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:path/path.dart' as path;
import 'package:webdriver/async_io.dart';

void main() async {
  const extensionPath = './integration_test/extension-wallet';

  final chromedriver =
      await Process.start('chromedriver', ['--port=4444', '--url-base=wd/hub']);

  await Future.delayed(const Duration(seconds: 2));

  final options = {
    'args': [
      '--load-extension=$extensionPath',
      '--disable-dev-shm-usage',
      '--no-sandbox',
    ],
  };

  final driver = await createDriver(
    uri: Uri.parse('http://localhost:4444/wd/hub/'),
    desired: {
      'browserName': 'chrome',
      'goog:chromeOptions': options,
    },
  );
  await driver.timeouts.setImplicitTimeout(const Duration(seconds: 60));
  await driver
      .get('chrome-extension://hmbohmbpddljjdejnpdomihefihbpifa/index.html#/');
  const addWalletBy = By.xpath('//span[text()="Add Wallet"]');
  final addWalletButton = await driver.findElement(addWalletBy);
  await addWalletButton.click();

  const importWalletBy = By.xpath('//span[text()="Import an old wallet"]');
  final importWalletButton = await driver.findElement(importWalletBy);
  await importWalletButton.click();

  final baseDir = path.dirname(Platform.script.toFilePath());
  var filePath = path.join(baseDir, './eternl-test-wallet.json');
  filePath = path.normalize(filePath);

  const inputFileBy = By.xpath(
    '//input[@id="files"]',
  );
  final inputFile = await driver.findElement(inputFileBy);
  await inputFile.sendKeys(filePath);

  // Connect to dapp
  const addedWalletBy = By.xpath(
    '//span[text()="My Wallets"]/parent::div/parent::div/following-sibling::div',
  );
  final addedWalletButton = await driver.findElement(addedWalletBy);
  await addedWalletButton.click();

  const connectBy = By.xpath(
    '//span[text()="Buy"]/parent::div/parent::div/preceding-sibling::div[2]',
  );
  final connectButton = await driver.findElement(connectBy);
  await connectButton.click();

  await Future.delayed(const Duration(seconds: 10));
  // Go to web app
  await driver.get('http://localhost:8000/');

  // await driver.quit();
  // await chromedriver.kill();

  // final wallets = await CatalystCardanoPlatform.instance.getWallets();
  // print('wallets are');
  // print(wallets);
  // final api = await wallets.first.enable();
  // final balance = await api.getBalance();
}
