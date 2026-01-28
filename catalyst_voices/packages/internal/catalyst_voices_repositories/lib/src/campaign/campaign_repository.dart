import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:collection/collection.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository(
    ProposalDocumentDataLocalSource source,
    AppMetaStorage appMetaStorage,
  ) = CampaignRepositoryImpl;

  Future<List<Campaign>> getAllCampaigns();

  /// Returns last known app active campaign.
  ///
  /// See [updateAppActiveCampaignId].
  Future<DocumentRef?> getAppActiveCampaignId();

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory?> getCategory(DocumentParameters parameters);

  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  /// Stores persistently active campaign [id].
  ///
  /// See [getAppActiveCampaignId].
  Future<void> updateAppActiveCampaignId({required DocumentRef? id});

  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });
}

final class CampaignRepositoryImpl implements CampaignRepository {
  final ProposalDocumentDataLocalSource _proposalsSource;
  final AppMetaStorage _appMetaStorage;

  const CampaignRepositoryImpl(
    this._proposalsSource,
    this._appMetaStorage,
  );

  @override
  Future<List<Campaign>> getAllCampaigns() async {
    return Campaign.all;
  }

  @override
  Future<DocumentRef?> getAppActiveCampaignId() {
    return _appMetaStorage.read().then((value) => value.activeCampaign);
  }

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    for (final campaign in Campaign.all) {
      if (id == campaign.id.id) {
        return campaign;
      }
    }
    throw CampaignNotFoundException(id: id);
  }

  @override
  Future<CampaignCategory?> getCategory(DocumentParameters parameters) async {
    return Campaign.all
        .expand((element) => element.categories)
        .firstWhereOrNull((e) => parameters.containsId(e.id.id));
  }

  @override
  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    return _proposalsSource.getProposalsTotalTask(nodeId: nodeId, filters: filters);
  }

  @override
  Future<void> updateAppActiveCampaignId({required DocumentRef? id}) async {
    final appMeta = await _appMetaStorage.read();
    final updatedAppMeta = appMeta.copyWith(activeCampaign: Optional(id));
    await _appMetaStorage.write(updatedAppMeta);
  }

  @override
  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    return _proposalsSource.watchProposalsTotalTask(nodeId: nodeId, filters: filters);
  }
}
