import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:webdriver/async_io.dart' as async_io;

Future<WebFlutterDriver> createVoicesWebDriver({
  String? hostUrl,
  bool printCommunication = true,
  bool logCommunicationToFile = true,
  Duration? timeout,
}) async {
  // Construct the full path to the extension
  const extensionPath =
      '/Users/ryszardschossler/Developer/other/tutorial/flutter_drive/lib/test_driver/eternl';
  // // final extensionPath =
  // //     "https://clients2.google.com/service/update2/crx?response=redirect&os=win&arch=x64&os_arch=x86_64&nacl_arch=x86-64&prod=chromiumcrx&prodchannel=beta&prodversion=79.0.3945.53&lang=ru&acceptformat=crx3&x=id%3Dkmhcihpebfmpgmihbkipmjlmmioameka%26installsource%3Dondemand%26uc";

  final driverCapabilities =
      json.decode(Platform.environment['DRIVER_SESSION_CAPABILITIES']!)
          as Map<String, dynamic>;
  final browserName = driverCapabilities['browserName'] as String;
  final browserKeyArgs = browserName.contains('chrome')
      ? 'goog:chromeOptions'
      : 'moz:firefoxOptions';
  final browsersArgs =
      driverCapabilities[browserKeyArgs] as Map<String, dynamic>;
  final Directory dataDir =
      fs.systemTempDirectory.createTempSync('flutter_tool.');
  final updatedDriverCapabilities = <String, dynamic>{
    'browserName': browserName,
    browserKeyArgs: {
      'args': [
        ...(browsersArgs['args'] as List<dynamic>? ?? <String>[])
            .cast<String>(),
        '--user-data-dir=${dataDir.path}',
        '--disable-extensions-except=$extensionPath',
        '--load-extension=$extensionPath',
        '--disable-gpu',
        '--disable-renderer-backgrounding',
        '--disable-search-engine-choice-screen',
        '--no-first-run',
        '--enable-automation',
        '--enable-extension-automation',
        '--allow-insecure-localhost',
      ],
    },
  };
  final sessionUri =
      Uri.parse(Platform.environment['DRIVER_SESSION_URI'].toString());

  final driver = await async_io.createDriver(
    uri: sessionUri,
    desired: updatedDriverCapabilities,
  );

  hostUrl ??= Platform.environment['VM_SERVICE_URL'];
  await driver.get(hostUrl!);
  await waitUntilExtensionInstalled(driver, timeout);

  final supportTimeLineAction =
      Platform.environment['SUPPORT_TIMELINE_ACTION'] == 'true';
  final connection = FlutterWebConnection(driver, supportTimeLineAction);

  return WebFlutterDriver.connectedTo(
    connection,
    printCommunication: printCommunication,
    logCommunicationToFile: logCommunicationToFile,
  );
}
