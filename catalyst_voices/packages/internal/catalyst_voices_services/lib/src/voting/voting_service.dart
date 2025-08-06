import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;

  const VotingMockService(this._votingRepository);

  @override
  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref) {
    return _votingRepository.getProposalVoteInfoFor(ref);
  }

  @override
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type) async{
    return _votingRepository.setCurrentDraft(ref, type);
  }

  @override
  void setLastCasted(DocumentRef ref) {
    _votingRepository.setLastCasted(ref);
  }

  @override
  ValueStream<List<ProposalVotes>> watchProposalVotes() {
    return _votingRepository.watchProposalVotes;
  }
}

abstract interface class VotingService {
  const factory VotingService(VotingRepository votingRepository) = VotingMockService;

  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref);
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type);
  void setLastCasted(DocumentRef ref);

  ValueStream<List<ProposalVotes>> watchProposalVotes();
}
