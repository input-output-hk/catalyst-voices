import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/discovery/campaign_hero_section_page.dart';
import '../pageobject/proposals_page.dart';
import '../utils/test_utils.dart';

void proposalsTests() {
  GoRouter? router;

  setUp(() {
    final initialLocation = const ProposalsRoute().location;
    router = AppRouterFactory.create(initialLocation: initialLocation);
  });

  tearDown(() {
    router = null;
  });

  patrolWidgetTest(
    'visitor - page is rendered correctly',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).looksAsExpectedForVisitor();
    },
  );

  patrolWidgetTest(
    'visitor - campaign details button works',
    // TODO(emiride): bring it back after voting_as_individual is merged.
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).campaignDetailsButtonWorks();
    },
  );

  patrolWidgetTest(
    'visitor - campaign details screen looks as expected',
    // TODO(emiride): bring it back after voting_as_individual is merged.
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).campaignDetailsScreenLooksAsExpected();
    },
  );

  patrolWidgetTest(
    'visitor - campaign details screen close button works',
    // TODO(emiride): bring it back after voting_as_individual is merged.
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).campaignDetailsCloseButtonWorks();
    },
  );

  patrolWidgetTest(
    'visitor - draft tab displays only draft proposals',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).clickDraftTab();
      await ProposalsPage($).checkProposalsStageMatch('Draft');
    },
  );

  patrolWidgetTest(
    'visitor - final tab displays only final proposals',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).clickFinalTab();
      await ProposalsPage($).checkProposalsStageMatch('Final');
    },
  );

  patrolWidgetTest(
    'visitor - pagination works for all proposals',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).paginationWorks();
    },
  );

  patrolWidgetTest(
    'visitor - pagination works for draft proposals',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).clickDraftTab();
      await ProposalsPage($).paginationWorks();
    },
  );

  patrolWidgetTest(
    'visitor - add proposal to favorites',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).proposalsCountIs('Favorite', 0);
      await $(ProposalsPage($).allProposalsTab).tap();
      await ProposalsPage($).proposalFavoriteBtnTap(0);
      await ProposalsPage($).proposalsCountIs('Favorite', 1);
    },
  );

  patrolWidgetTest(
    'visitor - remove proposal from favorites, in favorites tab',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).proposalFavoriteBtnTap(0);
      await ProposalsPage($).proposalsCountIs('Favorite', 1);
      await ProposalsPage($).proposalFavoriteBtnTap(0);
      await ProposalsPage($).proposalsCountIs('Favorite', 0);
    },
  );

  patrolWidgetTest(
    'visitor - remove proposal from favorites, in all tab',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).proposalFavoriteBtnTap(0);
      await ProposalsPage($).proposalsCountIs('Favorite', 1);
      await $(ProposalsPage($).allProposalsTab).tap();
      await ProposalsPage($).proposalFavoriteBtnTap(0);
      await ProposalsPage($).proposalsCountIs('Favorite', 0);
    },
  );

  patrolWidgetTest(
    'visitor - share links are working',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).proposalLinksAreWorkingFor(0);
    },
  );

  patrolWidgetTest(
    'visitor - share modal close button works',
    // TODO(emiride): this test in incorrect. Backend just do not return proposals
    skip: true,
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).shareModalCloseButtonWorks();
    },
  );

  patrolWidgetTest(
    'visitor - back button works',
    (PatrolTester $) async {
      await TestStateUtils.pumpApp($, router: router);

      await ProposalsPage($).clickBackButton();
      await CampaignHeroSection($).campaignBriefTitleIsRenderedCorrectly();
    },
  );
}
