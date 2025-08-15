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

  setUpAll(() async {
    binding.testTextInput.register();

    // F14
    final f14Campaign = CurrentCampaignX.staticContent;
    CampaignRepository.currentCampaign = f14Campaign;

    final proposalSubmissionTimeline = CurrentCampaignX.staticContent.timeline
        .firstWhere((element) => element.stage == CampaignTimelineStage.proposalSubmission)
        .timeline;

    final middle = proposalSubmissionTimeline.middle();

    DateTimeExt.mockedDateTime = middle;
  });

  setUp(() async {
    await bootstrap();

    await loggingService.updateSettings(printToConsole: const Optional(false));

    await Dependencies.instance.get<SyncManager>().isSynchronization;
  });

  tearDown(() async {
    await Dependencies.instance.get<CatalystDatabase>().pendingOperations;
    await cleanUpStorages();
    await cleanUpUserDataFromDatabase();
    await Dependencies.instance.reset;
  });

  tearDownAll(() {
    binding.testTextInput.unregister();
  });

  group('App -', appTests);
  group('Account -', accountTests);
  group('Discovery space -', discoverySpaceTests);
  group('Proposals space -', proposalsTests);
}
