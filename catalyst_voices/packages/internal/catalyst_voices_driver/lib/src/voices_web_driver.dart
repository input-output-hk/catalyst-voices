import 'dart:convert';
import 'dart:io';

import 'package:catalyst_voices_driver/src/extension.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:webdriver/async_io.dart' as async_io;

class VoicesWebDriver extends WebFlutterDriver {
  VoicesWebDriver.connectedTo(
    super.connection, {
    super.printCommunication = true,
    super.logCommunicationToFile = true,
  }) : super.connectedTo();

  static Future<VoicesWebDriver> create(
    List<Extension> extensions, {
    String? hostUrl,
    bool printCommunication = true,
    bool logCommunicationToFile = true,
    Duration? timeout,
  }) async {
    final driverCapabilities =
        json.decode(Platform.environment['DRIVER_SESSION_CAPABILITIES']!)
            as Map<String, dynamic>;
    final browserName = driverCapabilities['browserName'] as String;

    final extensionsPath =
        extensions
            .where((e) => e.browser.name == browserName)
            .map((e) => e.extensionPath)
            .toList();

    final sessionUri = Uri.parse(
      Platform.environment['DRIVER_SESSION_URI'].toString(),
    );

    final driver = await async_io.createDriver(
      uri: sessionUri,
      desired: _driverCapabilites(extensionsPath),
    );

    final finalHostUrl = hostUrl ?? Platform.environment['VM_SERVICE_URL']!;
    await driver.get(finalHostUrl);
    await waitUntilExtensionInstalled(driver, timeout);

    final supportTimeLineAction =
        Platform.environment['SUPPORT_TIMELINE_ACTION'] == 'true';
    final connection = FlutterWebConnection(driver, supportTimeLineAction);

    return VoicesWebDriver.connectedTo(
      connection,
      printCommunication: printCommunication,
      logCommunicationToFile: logCommunicationToFile,
    );
  }

  static Map<String, dynamic> _driverCapabilites(List<String?> extensionsPath) {
    final extensionPathString = _createPathExtension(extensionsPath);
    final driverCapabilities =
        json.decode(Platform.environment['DRIVER_SESSION_CAPABILITIES']!)
            as Map<String, dynamic>;
    final browserName = driverCapabilities['browserName'] as String;
    final browserKeyArgs =
        browserName.contains('chrome')
            ? 'goog:chromeOptions'
            : 'moz:firefoxOptions';
    final browsersArgs =
        driverCapabilities[browserKeyArgs] as Map<String, dynamic>;
    final Directory dataDir = fs.systemTempDirectory.createTempSync(
      'flutter_tool.',
    );
    final updatedDriverCapabilities = <String, dynamic>{
      'browserName': browserName,
      browserKeyArgs: {
        'args': [
          ...(browsersArgs['args'] as List<dynamic>? ?? <String>[])
              .cast<String>(),
          '--user-data-dir=${dataDir.path}',
          '--disable-extensions-except=$extensionPathString',
          '--load-extension=$extensionPathString',
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

    return updatedDriverCapabilities;
  }

  static String _createPathExtension(List<String?> extensions) {
    return extensions.where((e) => e != null).join(',');
  }
}
