import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/voting/casted_votes_observer.dart';

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

  Future<void> _loadCastedVotes() async {
    // TODO(LynxLynxx): Load casted votes from storage or remote source

    // Initialize with empty list if no votes are loaded
    votes = <Vote>[];
  }
}

abstract interface class VotingRepository implements CastedVotesObserver {
  factory VotingRepository(CastedVotesObserver votesObserver) = VotingMockRepository;

  Stream<List<Vote>> get watchedCastedVotes;

  Future<void> castVotes(List<Vote> draftVotes);
}
