import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/voting/casted_votes_observer.dart';
import 'package:collection/collection.dart';

final class VotingMockRepository implements VotingRepository {
  final CastedVotesObserver _votesObserver;

  VotingMockRepository(this._votesObserver) {
    unawaited(_loadCastedVotes());
  }

  @override
  List<Vote> get votes => _votesObserver.votes;

  @override
  set votes(List<Vote> value) => _votesObserver.votes = value;

  @override
  Stream<List<Vote>> get watchCastedVotes => _votesObserver.watchCastedVotes;

  @override
  Stream<List<Vote>> get watchedCastedVotes => watchCastedVotes;

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    final castedVotes = <Vote>[];

    for (final vote in draftVotes) {
      castedVotes.add(vote.toCasted());
    }

    // TODO(LynxLynxx): Save casted votes to storage or remote source

    // Create a map for efficient lookup and updates
    final votesMap = {for (final vote in votes) vote.proposal: vote};

    // Update or add new votes
    for (final newVote in castedVotes) {
      votesMap[newVote.proposal] = newVote;
    }
    votes = votesMap.values.toList();
  }

  @override
  Future<void> dispose() async {
    await _votesObserver.dispose();
  }

  @override
  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef) async {
    return _votesObserver.votes.firstWhereOrNull((vote) => vote.proposal == proposalRef);
  }

  Future<void> _loadCastedVotes() async {
    // TODO(LynxLynxx): Load casted votes from storage or remote source

    // Initialize with empty list if no votes are loaded
    votes = <Vote>[
      // TODO(LynxLynxx): For testing
      Vote.draft(
        proposal: const SignedDocumentRef(
          id: '01987a80-316f-7c5c-ac9a-5e17438222c9',
          version: '01987ea2-e771-7353-9816-5c9e4864553d',
        ),
        type: VoteType.yes,
      ).toCasted(),
    ];
  }
}

abstract interface class VotingRepository implements CastedVotesObserver {
  factory VotingRepository(CastedVotesObserver votesObserver) = VotingMockRepository;

  Stream<List<Vote>> get watchedCastedVotes;

  Future<void> castVotes(List<Vote> draftVotes);

  Future<Vote?> getProposalLastCastedVote(DocumentRef proposalRef);
}
