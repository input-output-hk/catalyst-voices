import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

final class VotingMockRepository implements VotingRepository {
  final _votesStreamController = StreamController<List<ProposalVotes>>.broadcast();
  final List<ProposalVotes> _cachedVotes = [];

  VotingMockRepository();

  @override
  Stream<List<ProposalVotes>> get watchProposalVotes => _votesStreamController.stream;

  @override
  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref) async {
    return _cachedVotes.firstWhereOrNull((proposal) => proposal.proposalRef == ref);
  }

  @override
  Future<List<ProposalVotes>> getProposalVotes() async {
    return List.from(_cachedVotes);
  }

  @override
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type) async {
    final proposalVoteIndex = _cachedVotes.indexWhere((proposal) => proposal.proposalRef == ref);

    if (type == null) {
      _cachedVotes.removeWhere((proposal) => proposal.proposalRef == ref);
      _votesStreamController.add(List.from(_cachedVotes));
      return null;
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
    return _cachedVotes.firstWhereOrNull((proposal) => proposal.proposalRef == ref);
  }

  @override
  void setLastCasted(DocumentRef ref) {
    // TODO(LynxLynxx): Implement it
  }
}

abstract interface class VotingRepository {
  factory VotingRepository() => VotingMockRepository();

  Stream<List<ProposalVotes>> get watchProposalVotes;
  Future<ProposalVotes?> getProposalVoteInfoFor(DocumentRef ref);
  Future<List<ProposalVotes>> getProposalVotes();
  Future<ProposalVotes?> setCurrentDraft(DocumentRef ref, VoteType? type);

  void setLastCasted(DocumentRef ref);
}
