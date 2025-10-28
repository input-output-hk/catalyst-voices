import 'package:catalyst_voices_repositories/src/database/model/joined_proposal_brief_entity.dart';

abstract interface class ProposalsV2DaoPagingStrategy {
  Future<int> countVisibleProposals();

  Future<List<JoinedProposalBriefEntity>> queryVisibleProposalsPage(int page, int size);
}
