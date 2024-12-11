import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

// ignore: one_member_abstracts
abstract interface class ProposalService {
  factory ProposalService(
    ProposalRepository proposalRepository,
  ) {
    return ProposalServiceImpl(
      proposalRepository,
    );
  }

  /// Fetches proposals for the [campaignId].
  Future<List<Proposal>> getProposals({required String campaignId});
}

final class ProposalServiceImpl implements ProposalService {
  final ProposalRepository _proposalRepository;

  const ProposalServiceImpl(
    this._proposalRepository,
  );

  @override
  Future<List<Proposal>> getProposals({required String campaignId}) async {
    final proposals =
        await _proposalRepository.getProposals(campaignId: campaignId);

    return proposals;
  }
}
