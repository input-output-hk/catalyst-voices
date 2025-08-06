import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;

  const VotingMockService(this._votingRepository);

  @override
  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref) {
    return _votingRepository.getProposalVoteInfoFor(ref);
  }

  @override
  Future<List<ProposalVotes>> getProposalVotes() async {
    return _votingRepository.getProposalVotes();
  }

  @override
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type) async {
    return _votingRepository.setCurrentDraft(ref, type);
  }

  @override
  void setLastCasted(DocumentRef ref) {
    return _votingRepository.setLastCasted(ref);
  }

  @override
  Stream<List<ProposalVotes>> watchProposalVotes() {
    return _votingRepository.watchProposalVotes;
  }
}

abstract interface class VotingService {
  const factory VotingService(VotingRepository votingRepository) = VotingMockService;

  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref);
  Future<List<ProposalVotes>> getProposalVotes();
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type);
  void setLastCasted(DocumentRef ref);

  Stream<List<ProposalVotes>> watchProposalVotes();
}
