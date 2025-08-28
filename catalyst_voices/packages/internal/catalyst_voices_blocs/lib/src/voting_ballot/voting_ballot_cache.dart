import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotCache extends Equatable {
  final Campaign? campaign;
  final Map<DocumentRef, VoteProposal> votesProposals;

  const VotingBallotCache({
    this.campaign,
    this.votesProposals = const {},
  });

  @override
  List<Object?> get props => [
    campaign,
    votesProposals,
  ];

  int get votesCount => votesProposals.length;

  VotingBallotCache addProposal(VoteProposal proposal) {
    final votesProposals = Map.of(this.votesProposals);

    votesProposals[proposal.ref] = proposal;

    return copyWith(votesProposals: votesProposals);
  }

  VotingBallotCache copyWith({
    Optional<Campaign>? campaign,
    Map<DocumentRef, VoteProposal>? votesProposals,
  }) {
    return VotingBallotCache(
      campaign: campaign.dataOr(this.campaign),
      votesProposals: votesProposals ?? this.votesProposals,
    );
  }

  VotingBallotCache removeProposal(DocumentRef ref) {
    final votesProposals = Map.of(this.votesProposals)..remove(ref);

    return copyWith(votesProposals: votesProposals);
  }
}
