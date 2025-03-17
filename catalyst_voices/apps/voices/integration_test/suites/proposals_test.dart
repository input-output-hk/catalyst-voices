import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:patrol_finders/patrol_finders.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../pageobject/proposals_page.dart';
import '../utils/mockUrlLauncher.dart';

void main() async {
  late final GoRouter router;
  late MockUrlLauncher mockUrlLauncherPlatform;

  setUpAll(() async {
    router = buildAppRouter();
    registerFallbackValue(
      FakeLaunchOptions(),
    ); // Register the fake for LaunchOptions
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
    router.go(const ProposalsRoute().location);
    mockUrlLauncherPlatform = MockUrlLauncher();
    UrlLauncherPlatform.instance = mockUrlLauncherPlatform;
  });

  tearDown(() async {
    await restartDependencies();
  });

  patrolWidgetTest(
    'visitor - share modal close button works',
    (PatrolTester $) async {
      final testUrl = Uri.parse('https://example.com');
      await $.pumpWidgetAndSettle(App(routerConfig: router));

      // Stub method to return true
      when(
        () => mockUrlLauncherPlatform.launchUrl(
          testUrl.toString(),
          any<LaunchOptions>(),
        ),
      ).thenAnswer((_) async => true);

      // Call the actual launch function
      await ProposalsPage($).clickOnShare1();

      // Validate
      // expect(result, isTrue);
      verify(
        () => mockUrlLauncherPlatform.launchUrl(
          testUrl.toString(),
          any<LaunchOptions>(),
        ),
      ).called(1);
    },
  );

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
      'visitor - share links are displayed',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).proposalLinksAreDisplayedFor(0);
      },
    );

    patrolWidgetTest(
      'visitor - share modal close button works',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).shareModalCloseButtonWorks();
      },
    );
  }, skip: true);
}
