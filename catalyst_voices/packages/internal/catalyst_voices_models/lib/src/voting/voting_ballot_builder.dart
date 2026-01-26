import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

/// Builder utility for working with [Vote]s.
abstract interface class VotingBallotBuilder implements Listenable {
  /// Numbers of votes in this ballot.
  int get length;

  /// Returns unmodifiable copy of votes made.
  List<Vote> get votes;

  /// Emits list of votes when changed
  Stream<List<Vote>> get watchVotes;

  /// Adds [vote] to the list.
  void addVote(Vote vote);

  /// Builds [VotingBallot] with unmodifiable list of votes.
  VotingBallot build();

  /// Removes votes from this builder.
  void clear();

  /// Release resources.
  void dispose();

  /// Returns [Vote] made on [proposal].
  Vote? getVoteOn(DocumentRef proposal);

  /// Lookup if has draft votes on [proposal].
  bool hasVotedOn(DocumentRef proposal);

  /// Removes [Vote] on [proposal].
  Vote? removeVoteOn(DocumentRef proposal);

  /// Updates vote made on [proposal] if already had any or adds new draft vote otherwise.
  ///
  /// Returns current [Vote] on [proposal] after update.
  ///
  /// [voteId] is optional argument which will be used on new draft votes with
  /// fresh version.
  Vote voteOn({
    required DocumentRef proposal,
    required VoteType type,
    String? voteId,
  });
}
