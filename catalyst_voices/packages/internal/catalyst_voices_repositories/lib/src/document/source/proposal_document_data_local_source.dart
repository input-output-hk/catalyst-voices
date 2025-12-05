import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Specialized version of local documents source. Proposals often
/// require very specific logic and queries and its very hard and to
/// implement those queries in abstract way without know all logic related
/// just to proposals.
abstract interface class ProposalDocumentDataLocalSource {
  Future<ProposalsTotalAsk> getProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  Stream<Page<JoinedProposalBriefData>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  Stream<ProposalsTotalAsk> watchProposalsTotalTask({
    required NodeId nodeId,
    required ProposalsTotalAskFilters filters,
  });

  Stream<List<DocumentData>> watchProposalTemplates({
    required CampaignFilters campaign,
  });
}
