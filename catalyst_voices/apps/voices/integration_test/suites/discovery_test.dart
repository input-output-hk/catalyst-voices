import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/discovery/current_campaign_selector_page.dart';
import '../pageobject/discovery_page.dart';
import '../pageobject/proposals_page.dart';
import '../utils/bootstrap_utils.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerForTests();
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartForTests();
  });

  group('Discovery space -', () {
    patrolWidgetTest(
      'visitor - page is rendered correctly',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await DiscoveryPage($).looksAsExpectedForVisitor();
      },
    );

    patrolWidgetTest(
      'visitor - view proposals button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await DiscoveryPage($).viewProposalsBtnClick();
        await ProposalsPage($).currentCampaignDetailsLooksAsExpected();
      },
    );

    patrolWidgetTest(
      'visitor - timeline cards data is rendered',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await CurrentCampaignSection($).timelineCardsDataIsRendered();
      },
    );
  });
}
