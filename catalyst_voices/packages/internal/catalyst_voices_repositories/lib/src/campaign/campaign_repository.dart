import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:collection/collection.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository(ProposalDocumentDataLocalSource source) = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory?> getCategory(DocumentParameters parameters);

  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });
}

final class CampaignRepositoryImpl implements CampaignRepository {
  final ProposalDocumentDataLocalSource _source;

  const CampaignRepositoryImpl(this._source);

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    for (final campaign in Campaign.all) {
      if (id == campaign.id.id) {
        return campaign;
      }
    }
    throw NotFoundException(message: 'Campaign $id not found');
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
    return _source.getProposalsTotalTask(nodeId: nodeId, filters: filters);
  }

  @override
  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  }) {
    return _source.watchProposalsTotalTask(nodeId: nodeId, filters: filters);
  }
}
