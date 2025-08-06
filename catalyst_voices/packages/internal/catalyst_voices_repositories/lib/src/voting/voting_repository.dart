import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockRepository implements VotingRepository {
  final _votesStreamController = BehaviorSubject<List<ProposalVotes>>.seeded([]);
  final List<ProposalVotes> _cachedVotes = [];

  VotingMockRepository();

  @override
  ValueStream<List<ProposalVotes>> get watchProposalVotes => _votesStreamController.stream;

  @override
  void setCurrentDraft(SignedDocumentRef ref, VoteType? type) {
    final proposalVoteIndex = _cachedVotes.indexWhere((proposal) => proposal.proposalRef == ref);

    if (type == null) {
      _cachedVotes.removeWhere((proposal) => proposal.proposalRef == ref);
      _votesStreamController.add(List.from(_cachedVotes));
      return;
    }

    final vote = Vote.draft(
      proposal: ref,
      type: type,
    );

    if (proposalVoteIndex != -1) {
      _cachedVotes[proposalVoteIndex] =
          _cachedVotes[proposalVoteIndex].copyWith(currentDraft: Optional(vote));
    } else {
      _cachedVotes.add(ProposalVotes(proposalRef: ref, currentDraft: vote));
    }

    _votesStreamController.add(List.from(_cachedVotes));
  }

  @override
  void setLastCasted(SignedDocumentRef ref) {
    // TODO(LynxLynxx): Implement it
  }
}

abstract interface class VotingRepository {
  factory VotingRepository() => VotingMockRepository();

  ValueStream<List<ProposalVotes>> get watchProposalVotes;
  void setCurrentDraft(SignedDocumentRef ref, VoteType? type);

  void setLastCasted(SignedDocumentRef ref);
}
