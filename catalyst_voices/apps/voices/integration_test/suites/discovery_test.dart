import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/discovery/current_campaign_selector_page.dart';
import '../pageobject/discovery_page.dart';
import '../pageobject/proposals_page.dart';
import '../utils/test_utils.dart';

void discoverySpaceTests() {
  patrolWidgetTest(
    'visitor - page is rendered correctly',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($);

      await Future<void>.delayed(const Duration(seconds: 1));
      await $.pumpAndTrySettle();

      await DiscoveryPage($).looksAsExpectedForVisitor();
    },
  );

  patrolWidgetTest(
    'visitor - view proposals button works',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($);

      await Future<void>.delayed(const Duration(seconds: 1));
      await $.pumpAndTrySettle();

      await DiscoveryPage($).viewProposalsBtnClick();
      await ProposalsPage($).currentCampaignDetailsLooksAsExpected();
    },
  );

  patrolWidgetTest(
    'visitor - timeline cards data is rendered',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($);

      await Future<void>.delayed(const Duration(seconds: 1));
      await $.pumpAndTrySettle();

      await CurrentCampaignSection($).timelineCardsDataIsRendered();
    },
  );
}
