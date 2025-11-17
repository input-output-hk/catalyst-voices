import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:collection/collection.dart';

/// Allows access to campaign data, categories, and timeline.
abstract interface class CampaignRepository {
  const factory CampaignRepository(ProposalDocumentDataLocalSource source) = CampaignRepositoryImpl;

  Future<Campaign> getCampaign({
    required String id,
  });

  Future<CampaignCategory?> getCategory(SignedDocumentRef ref);

  Stream<Map<DocumentRef, ProposalTemplateTotalAsk>> watchProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
  });
}

final class CampaignRepositoryImpl implements CampaignRepository {
  final ProposalDocumentDataLocalSource _source;

  const CampaignRepositoryImpl(this._source);

  @override
  Future<Campaign> getCampaign({
    required String id,
  }) async {
    if (id == Campaign.f15Ref.id) {
      return Campaign.f15();
    }
    if (id == Campaign.f14Ref.id) {
      return Campaign.f14();
    }
    throw NotFoundException(message: 'Campaign $id not found');
  }

  @override
  Future<CampaignCategory?> getCategory(SignedDocumentRef ref) async {
    return Campaign.all
        .expand((element) => element.categories)
        .firstWhereOrNull((e) => e.selfRef.id == ref.id);
  }

  @override
  Stream<Map<DocumentRef, ProposalTemplateTotalAsk>> watchProposalTemplatesTotalTask({
    required CampaignFilters filters,
    required NodeId nodeId,
  }) {
    return _source.watchProposalTemplatesTotalTask(filters: filters, nodeId: nodeId);
  }
}
