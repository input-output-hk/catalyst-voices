import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'suites/account_test.dart' as account;
import 'suites/app_test.dart' as app;
import 'utils/test_utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    debugPrint('AllTest -> SetUpAll');
    binding.testTextInput.register();

    final bootstrapArgs = await bootstrap();

    testsRouter = bootstrapArgs.routerConfig as GoRouter;

    debugPrint('Awaiting initial synchronization');
    final isSyncSuccess = await Dependencies.instance.get<SyncManager>().isSynchronization;
    debugPrint('Synchronization completed with success[$isSyncSuccess]');
  });

  setUp(() {
    debugPrint('AllTest -> SetUp');
  });

  tearDown(() async {
    debugPrint('AllTest -> TearDown');

    await TestStateUtils.clearAccounts();
  });

  tearDownAll(() {
    debugPrint('AllTest -> TearDownAll');
    binding.testTextInput.unregister();
  });

  group('App -', app.main);
  group('Account page -', account.main);
}

late final GoRouter testsRouter;
