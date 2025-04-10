import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Specialized version of local documents source. Proposals often
/// require very specific logic and queries and its very hard and to
/// implement those queries in abstract way without know all logic related
/// just to proposals.
abstract interface class ProposalDocumentDataLocalSource {
  Future<Page<ProposalDocumentData>> getProposalsPage({
    required PageRequest request,
    required ProposalsFilters filters,
  });

  Stream<ProposalsCount> watchProposalsCount({
    required ProposalsCountFilters filters,
  });
}
