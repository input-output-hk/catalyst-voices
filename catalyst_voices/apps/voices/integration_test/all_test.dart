import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'suites/suites.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    binding.testTextInput.register();
  });

  setUp(() async {
    debugPrint('AllTest -> SetUp');

    await bootstrap();

    await loggingService.updateSettings(printToConsole: const Optional(false));

    await Dependencies.instance.get<SyncManager>().isSynchronization;
  });

  tearDown(() async {
    debugPrint('AllTest -> TearDown');
    await cleanUpStorages();
    await cleanUpUserDataFromDatabase();
    await Dependencies.instance.reset;
  });

  tearDownAll(() {
    debugPrint('AllTest -> TearDownAll');
    binding.testTextInput.unregister();
  });

  group('App -', appTests);
}
