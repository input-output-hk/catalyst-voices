import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotCache extends Equatable {
  final Campaign? campaign;
  final bool isVotingActive;
  final AccountVotingRole? votingRole;
  final Map<DocumentRef, VoteProposal> votesProposals;

  const VotingBallotCache({
    this.campaign,
    this.isVotingActive = false,
    this.votingRole,
    this.votesProposals = const {},
  });

  @override
  List<Object?> get props => [
    campaign,
    isVotingActive,
    votingRole,
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
    bool? isVotingActive,
    Optional<AccountVotingRole>? votingRole,
    Map<DocumentRef, VoteProposal>? votesProposals,
  }) {
    return VotingBallotCache(
      campaign: campaign.dataOr(this.campaign),
      isVotingActive: isVotingActive ?? this.isVotingActive,
      votingRole: votingRole.dataOr(this.votingRole),
      votesProposals: votesProposals ?? this.votesProposals,
    );
  }

  VotingBallotCache removeProposal(DocumentRef ref) {
    final votesProposals = Map.of(this.votesProposals)..remove(ref);

    return copyWith(votesProposals: votesProposals);
  }
}
