import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';

/// Builder utility for working with [Vote]s.
final class VotingBallotBuilder {
  /// A map of votes casted on ref.
  final Map<DocumentRef, Vote> _votes;

  factory VotingBallotBuilder({
    List<Vote> votes = const [],
  }) {
    assert(votes.none((vote) => vote.isCasted), 'Can not add already casted votes');

    final votesMap = Map.fromEntries(votes.map((vote) => MapEntry(vote.ref, vote)));

    return VotingBallotBuilder._(votesMap);
  }

  VotingBallotBuilder._(this._votes);

  /// Numbers of votes in this ballot.
  int get length => _votes.length;

  /// Returns unmodifiable copy of votes made.
  List<Vote> get votes => List.unmodifiable(_votes.values);

  /// Builds [VotingBallot] with unmodifiable list of votes.
  VotingBallot build() {
    return VotingBallot(votes: votes);
  }

  /// Returns [Vote] made on [ref].
  Vote? getVoteOn(DocumentRef ref) => _votes[ref];

  /// Removes [Vote] on [ref].
  Vote? removeVoteOn(DocumentRef ref) => _votes.remove(ref);

  /// Updates vote made on [ref] if already had any or adds new draft vote otherwise.
  ///
  /// Returns current [Vote] on [ref] after update.
  Vote voteOn({
    required DocumentRef ref,
    required VoteType type,
  }) {
    return _votes.update(
      ref,
      (vote) => vote.copyWith(type: type),
      ifAbsent: () => Vote.draft(ref: ref, type: type),
    );
  }
}
