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

    final votesMap = Map.fromEntries(votes.map((vote) => MapEntry(vote.proposal, vote)));

    return VotingBallotBuilder._(votesMap);
  }

  VotingBallotBuilder._(this._votes);

  /// Numbers of votes in this ballot.
  int get length => _votes.length;

  /// Returns unmodifiable copy of votes made.
  List<Vote> get votes => List.unmodifiable(_votes.values);

  /// Adds [vote] to the list.
  void addVote(Vote vote) {
    assert(!vote.isCasted, 'Can not add already casted vote!');
    assert(
      () {
        final id = vote.selfRef.id;
        return _votes.values.every((vote) => vote.selfRef.id != id);
      }(),
      'Only one vote version is allowed',
    );

    _votes[vote.proposal] = vote;
  }

  /// Builds [VotingBallot] with unmodifiable list of votes.
  VotingBallot build() {
    return VotingBallot(votes: votes);
  }

  /// Returns [Vote] made on [proposal].
  Vote? getVoteOn(DocumentRef proposal) => _votes[proposal];

  /// Removes [Vote] on [proposal].
  Vote? removeVoteOn(DocumentRef proposal) => _votes.remove(proposal);

  /// Updates vote made on [proposal] if already had any or adds new draft vote otherwise.
  ///
  /// Returns current [Vote] on [proposal] after update.
  Vote voteOn({
    required DocumentRef proposal,
    required VoteType type,
  }) {
    return _votes.update(
      proposal,
      (vote) => vote.copyWith(type: type),
      ifAbsent: () => Vote.draft(proposal: proposal, type: type),
    );
  }
}
