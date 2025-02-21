import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../pageobject/discovery_page.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  group(
    'Discovery space -',
    () {
      patrolWidgetTest(
        'visitor - page is rendered correctly',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await DiscoveryPage($).looksAsExpectedForVisitor();
        },
      );
    },
  );
}
