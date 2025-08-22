import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final class VotingBallotLocalBuilder with ChangeNotifier implements VotingBallotBuilder {
  /// A map of votes casted on ref.
  final Map<DocumentRef, Vote> _votes;

  factory VotingBallotLocalBuilder({
    List<Vote> votes = const [],
  }) {
    assert(votes.none((vote) => vote.isCasted), 'Can not add already casted votes');

    final votesMap = Map.fromEntries(votes.map((vote) => MapEntry(vote.proposal, vote)));

    return VotingBallotLocalBuilder._(votesMap);
  }

  VotingBallotLocalBuilder._(this._votes);

  @override
  int get length => _votes.length;

  @override
  List<Vote> get votes => List.unmodifiable(_votes.values);

  @override
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
    notifyListeners();
  }

  @override
  VotingBallot build() {
    return VotingBallot(votes: votes);
  }

  @override
  void clear() {
    _votes.clear();
    notifyListeners();
  }

  @override
  Vote? getVoteOn(DocumentRef proposal) => _votes[proposal];

  @override
  bool hasVotedOn(DocumentRef proposal) => _votes.containsKey(proposal);

  @override
  Vote? removeVoteOn(DocumentRef proposal) {
    final vote = _votes.remove(proposal);

    if (vote != null) {
      notifyListeners();
    }

    return vote;
  }

  @override
  Vote voteOn({
    required DocumentRef proposal,
    required VoteType type,
    String? voteId,
  }) {
    final vote = _votes.update(
      proposal,
      (vote) => vote.copyWith(type: type),
      ifAbsent: () => Vote.draft(id: voteId, proposal: proposal, type: type),
    );

    notifyListeners();

    return vote;
  }
}
