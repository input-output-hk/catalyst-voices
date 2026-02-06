import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'suites/suites.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final f14Campaign = Campaign.f14();

  setUpAll(() async {
    binding.testTextInput.register();

    final proposalSubmissionTimeline = f14Campaign.timeline.phases
        .firstWhere((element) => element.type == CampaignPhaseType.proposalSubmission)
        .timeline;

    final middle = proposalSubmissionTimeline.middle();

    DateTimeExt.mockedDateTime = middle;
  });

  setUp(() async {
    await bootstrap();

    await loggingService.updateSettings(printToConsole: const Optional(false));

    await Dependencies.instance.get<CampaignService>().changeActiveCampaign(f14Campaign);
    await Dependencies.instance.get<SyncManager>().waitForActiveRequest;
  });

  tearDown(() async {
    await Dependencies.instance.get<CatalystDatabase>().pendingOperations;
    // TODO(damian-molinski): sometimes tests are flaky because of pending db queries
    // do not have time to finish. pendingOperations is not implemented correctly
    await Future<void>.delayed(const Duration(milliseconds: 500));

    await cleanUpStorages();
    await cleanUpUserDataFromDatabase();
    await Dependencies.instance.reset;
  });

  tearDownAll(() {
    binding.testTextInput.unregister();
  });

  group('App -', appTests, skip: _skipE2EReason);
  group('Account -', accountTests, skip: _skipE2EReason);
  group('Discovery space -', discoverySpaceTests, skip: _skipE2EReason);
  group('Onboarding -', onboardingTests, skip: _skipE2EReason);
  // TODO(emiride): rethink how to setup tests accounts in different environments for gateway.
  group('Onboarding Restore Flow -', onboardingRestoreTests, skip: _skipE2EReason);
  group('Proposals space -', proposalsTests, skip: _skipE2EReason);
}

const _skipE2EReason = 'No maintained. Playwright implementation in progress';
