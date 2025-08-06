import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotCache extends Equatable {
  final DateRange? votingTimeline;
  final Map<DocumentRef, VoteProposal> votesProposals;

  const VotingBallotCache({
    this.votingTimeline,
    this.votesProposals = const {},
  });

  @override
  List<Object?> get props => [
        votingTimeline,
        votesProposals,
      ];

  VotingBallotCache addProposal(VoteProposal proposal) {
    final votesProposals = Map.of(this.votesProposals);

    votesProposals[proposal.ref] = proposal;

    return copyWith(votesProposals: votesProposals);
  }

  VotingBallotCache copyWith({
    Optional<DateRange>? votingTimeline,
    Map<DocumentRef, VoteProposal>? votesProposals,
  }) {
    return VotingBallotCache(
      votingTimeline: votingTimeline.dataOr(this.votingTimeline),
      votesProposals: votesProposals ?? this.votesProposals,
    );
  }

  VotingBallotCache removeProposal(DocumentRef ref) {
    final votesProposals = Map.of(this.votesProposals)..remove(ref);

    return copyWith(votesProposals: votesProposals);
  }
}
