import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockService implements VotingService {
  final VotingRepository _votingRepository;

  const VotingMockService(this._votingRepository);

  @override
  void setCurrentDraft(SignedDocumentRef ref, VoteType? type) {
    _votingRepository.setCurrentDraft(ref, type);
  }

  @override
  void setLastCasted(SignedDocumentRef ref) {
    _votingRepository.setLastCasted(ref);
  }

  @override
  ValueStream<List<ProposalVotes>> watchProposalVotes() {
    return _votingRepository.watchProposalVotes;
  }
}

abstract interface class VotingService {
  const factory VotingService(VotingRepository votingRepository) = VotingMockService;

  void setCurrentDraft(SignedDocumentRef ref, VoteType? type);
  void setLastCasted(SignedDocumentRef ref);

  ValueStream<List<ProposalVotes>> watchProposalVotes();
}
