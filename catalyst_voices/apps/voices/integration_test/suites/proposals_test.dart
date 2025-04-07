import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/discovery/campaign_hero_section_page.dart';
import '../pageobject/proposals_page.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies();
    router.go(const ProposalsRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  group('Proposals space -', () {
    patrolWidgetTest(
      'visitor - page is rendered correctly',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).looksAsExpectedForVisitor();
      },
    );

    patrolWidgetTest(
      'visitor - campaign details button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).campaignDetailsButtonWorks();
      },
    );

    patrolWidgetTest(
      'visitor - campaign details screen looks as expected',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).campaignDetailsScreenLooksAsExpected();
      },
    );

    patrolWidgetTest(
      'visitor - campaign details screen close button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).campaignDetailsCloseButtonWorks();
      },
    );

    patrolWidgetTest(
      'visitor - draft tab displays only draft proposals',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).clickDraftTab();
        await ProposalsPage($).checkProposalsStageMatch('Draft');
      },
    );

    patrolWidgetTest(
      'visitor - final tab displays only final proposals',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).clickFinalTab();
        await ProposalsPage($).checkProposalsStageMatch('Final');
      },
    );

    patrolWidgetTest(
      'visitor - pagination works for all proposals',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).paginationWorks();
      },
    );

    patrolWidgetTest(
      'visitor - pagination works for draft proposals',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).clickDraftTab();
        await ProposalsPage($).paginationWorks();
      },
    );

    patrolWidgetTest(
      'visitor - add proposal to favorites',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).proposalsCountIs('Favorite', 0);
        await $(ProposalsPage($).allProposalsTab).tap();
        await ProposalsPage($).proposalFavoriteBtnTap(0);
        await ProposalsPage($).proposalsCountIs('Favorite', 1);
      },
    );

    patrolWidgetTest(
      'visitor - remove proposal from favorites, in favorites tab',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).proposalFavoriteBtnTap(0);
        await ProposalsPage($).proposalsCountIs('Favorite', 1);
        await ProposalsPage($).proposalFavoriteBtnTap(0);
        await ProposalsPage($).proposalsCountIs('Favorite', 0);
      },
    );

    patrolWidgetTest(
      'visitor - remove proposal from favorites, in all tab',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).proposalFavoriteBtnTap(0);
        await ProposalsPage($).proposalsCountIs('Favorite', 1);
        await $(ProposalsPage($).allProposalsTab).tap();
        await ProposalsPage($).proposalFavoriteBtnTap(0);
        await ProposalsPage($).proposalsCountIs('Favorite', 0);
      },
    );

    patrolWidgetTest(
      'visitor - share links are working',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).proposalLinksAreWorkingFor(0);
      },
    );

    patrolWidgetTest(
      'visitor - share modal close button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).shareModalCloseButtonWorks();
      },
    );

    patrolWidgetTest(
      'visitor - back button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).clickBackButton();
        await CampaignHeroSection($).campaignBriefTitleIsRenderedCorrectly();
      },
    );
  });
}
