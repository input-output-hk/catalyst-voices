import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:rxdart/rxdart.dart';

final class VotingMockRepository implements VotingRepository {
  // Using BehaviorSubject to get the last value of the stream after emission when someone subscribes to it
  final _castedVotesSC = BehaviorSubject<List<Vote>>();
  final _cachedCastedVotes = <Vote>[];

  VotingMockRepository() {
    unawaited(_loadCastedVotes());
  }

  @override
  ValueStream<List<Vote>> get watchedCastedVotes => _castedVotesSC;

  @override
  Future<void> castVotes(List<Vote> draftVotes) async {
    final castedVotes = <Vote>[];
    for (final vote in draftVotes) {
      castedVotes.add(vote.toCasted());
    }

    // TODO(LynxLynxx): Save casted votes to storage or remote source

    // Create a map for efficient lookup and updates
    final votesMap = {for (final vote in _cachedCastedVotes) vote.proposal: vote};

    // Update or add new votes
    for (final newVote in castedVotes) {
      votesMap[newVote.proposal] = newVote;
    }

    _cachedCastedVotes
      ..clear()
      ..addAll(votesMap.values);

    _castedVotesSC.add(List.from(_cachedCastedVotes));
  }

  Future<void> _loadCastedVotes() async {
    // TODO(LynxLynxx): Load casted votes from storage or remote source

    _castedVotesSC.add(List.from(_cachedCastedVotes));
  }
}

abstract interface class VotingRepository {
  factory VotingRepository() => VotingMockRepository();

  ValueStream<List<Vote>> get watchedCastedVotes;

  Future<void> castVotes(List<Vote> draftVotes);
}
