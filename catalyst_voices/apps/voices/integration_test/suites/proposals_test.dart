import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/proposals_page.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
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
        await ProposalsPage($).checkProposalsStageMatch(T.get('Draft'));
      },
    );

    patrolWidgetTest(
      'visitor - final tab displays only final proposals',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await ProposalsPage($).clickFinalTab();
        await ProposalsPage($).checkProposalsStageMatch(T.get('Final'));
      },
    );
  });
}
