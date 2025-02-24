import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'suites/account_test.dart' as account_test;
import 'suites/app_test.dart' as app_test;
import 'suites/discovery_test.dart' as discovery_test;
import 'suites/onboarding_test.dart' as onboarding_test;

void main() async {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.testTextInput.register();

  setUpAll(() async {
    await bootstrap(router: buildAppRouter());
  });

  app_test.main();
  onboarding_test.main();
  account_test.main();
  discovery_test.main();
}
