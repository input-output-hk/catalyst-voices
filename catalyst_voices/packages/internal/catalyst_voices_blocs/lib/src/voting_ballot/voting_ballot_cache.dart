import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotCache extends Equatable {
  final DateRange? votingTimeline;
  final TimezonePreferences? preferredTimezone;
  final Map<DocumentRef, VoteProposal> votesProposals;

  const VotingBallotCache({
    this.votingTimeline,
    this.preferredTimezone,
    this.votesProposals = const {},
  });

  @override
  List<Object?> get props => [
        votingTimeline,
        preferredTimezone,
        votesProposals,
      ];

  VotingBallotCache copyWith({
    Optional<DateRange>? votingTimeline,
    Optional<TimezonePreferences>? preferredTimezone,
    Map<DocumentRef, VoteProposal>? votesProposals,
  }) {
    return VotingBallotCache(
      votingTimeline: votingTimeline.dataOr(this.votingTimeline),
      preferredTimezone: preferredTimezone.dataOr(this.preferredTimezone),
      votesProposals: votesProposals ?? this.votesProposals,
    );
  }
}
