import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'app_test.dart' as app_test;
import 'onboarding_test.dart' as onboarding_test;

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await bootstrap(router: buildAppRouter());
  });

  app_test.main();
  onboarding_test.main();
}
