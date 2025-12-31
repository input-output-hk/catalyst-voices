import 'package:catalyst_voices/configs/app_bloc_observer.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

final class AppInitializationChoreographer {
  const AppInitializationChoreographer();

  Future<void> call(AppConfig config, Uri initialLocation) async {
    // Observer is very noisy on Logger. Enable it only if you want to debug something
    Bloc.observer = AppBlocObserver(logOnChange: false);

    if (config.stressTest.isEnabled && config.stressTest.clearDatabase) {
      await Dependencies.instance.get<CatalystDatabase>().clear();
    }

    Dependencies.instance.get<ReportingServiceMediator>().init();

    final isProposalInitialLocation = ProposalRoute.isPath(initialLocation);
    final initialDoc = isProposalInitialLocation
        ? ProposalRoute.fromPath(initialLocation).ref
        : null;
    final priorityDoc = initialDoc != null && initialDoc.isSigned
        ? initialDoc.toSignedDocumentRef()
        : null;

    await _syncDocuments(priorityDoc: priorityDoc);
  }

  Future<void> _syncDocuments({SignedDocumentRef? priorityDoc}) async {
    final requests = <DocumentsSyncRequest>[];

    if (priorityDoc != null) {
      requests.add(TargetSyncRequest(priorityDoc));
    }

    final campaignService = Dependencies.instance.get<CampaignService>();
    final campaign = await campaignService.initActiveCampaign();
    if (campaign != null) {
      requests.add(CampaignSyncRequest.periodic(campaign));
    }

    if (requests.isEmpty) return;

    final syncManager = Dependencies.instance.get<SyncManager>();
    for (final request in requests) {
      syncManager.queue(request);
    }
  }
}
