import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingCubitCache extends Equatable {
  final Campaign? campaign;
  final VotingPower? votingPower;
  final Page<ProposalWithContext>? page;
  final ProposalsFilters filters;
  final ProposalsCount count;
  final List<String>? favoriteIds;
  final List<Vote>? lastCastedVote;

  const VotingCubitCache({
    this.campaign,
    this.votingPower,
    this.page,
    this.filters = const ProposalsFilters(),
    this.count = const ProposalsCount(),
    this.favoriteIds,
    this.lastCastedVote,
  });

  @override
  List<Object?> get props => [
    campaign,
    votingPower,
    page,
    filters,
    count,
    favoriteIds,
    lastCastedVote,
  ];

  VotingCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<VotingPower>? votingPower,
    Optional<Page<ProposalWithContext>>? page,
    ProposalsFilters? filters,
    ProposalsCount? count,
    Optional<List<String>>? favoriteIds,
    Optional<List<Vote>>? lastCastedVote,
  }) {
    return VotingCubitCache(
      campaign: campaign.dataOr(this.campaign),
      votingPower: votingPower.dataOr(this.votingPower),
      page: page.dataOr(this.page),
      filters: filters ?? this.filters,
      count: count ?? this.count,
      favoriteIds: favoriteIds.dataOr(this.favoriteIds),
      lastCastedVote: lastCastedVote.dataOr(this.lastCastedVote),
    );
  }
}
