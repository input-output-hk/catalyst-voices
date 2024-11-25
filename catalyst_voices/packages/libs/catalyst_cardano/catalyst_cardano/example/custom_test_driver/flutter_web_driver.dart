import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/common.dart';
import 'package:integration_test/integration_test_driver.dart';
import 'package:webdriver/async_io.dart' as async_io;

Future<WebFlutterDriver> createCustomWebDriver({
  String? hostUrl,
  bool printCommunication = false,
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
  final updatedDriverCapabilities = <String, dynamic>{
    'browserName': browserName,
    browserKeyArgs: {
      'args': [
        ...(browsersArgs['args'] as List<dynamic>? ?? <String>[])
            .cast<String>(),
        '--disable-extensions-except=$extensionPath',
        '--load-extension=$extensionPath',
        '--disable-gpu',
        '--disable-search-engine-choice-screen',
      ],
    },
  };

  hostUrl ??= Platform.environment['VM_SERVICE_URL'];
  final sessionUri =
      Uri.parse(Platform.environment['DRIVER_SESSION_URI'].toString());
  final driver = await async_io.createDriver(
    uri: sessionUri,
    desired: updatedDriverCapabilities,
    spec: async_io.WebDriverSpec.W3c,
  );
  final windows = await driver.windows.toList();
  if (windows.length > 1) {
    final window = windows.first;
    await window.close();
    final lastWindow = windows.last;
    await lastWindow.setAsActive();
  }
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

Future<void> voicesIntegrationDriver({
  Duration timeout = const Duration(minutes: 20),
  ResponseDataCallback? responseDataCallback = writeResponseData,
  bool writeResponseOnFailure = false,
}) async {
  final webDriver = await createCustomWebDriver(timeout: timeout);

  final jsonResult = await webDriver.requestData(null, timeout: timeout);
  final response = Response.fromJson(jsonResult);

  final window = await webDriver.webDriver.window;
  await window.close();
  await webDriver.close();

  if (response.allTestsPassed) {
    print('All tests passed.');
    if (responseDataCallback != null) {
      await responseDataCallback(response.data);
    }
    exit(0);
  } else {
    print('Failure Details:\n${response.formattedFailureDetails}');
    if (responseDataCallback != null && writeResponseOnFailure) {
      await responseDataCallback(response.data);
    }
    exit(1);
  }
}
