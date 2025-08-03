import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingCubitCache extends Equatable {
  final Campaign? campaign;
  final VotingPower? votingPower;
  final Page<Proposal>? page;
  final ProposalsFilters filters;
  final ProposalsCount count;
  final List<String>? favoriteIds;

  const VotingCubitCache({
    this.campaign,
    this.votingPower,
    this.page,
    this.filters = const ProposalsFilters(),
    this.count = const ProposalsCount(),
    this.favoriteIds,
  });

  @override
  List<Object?> get props => [
        campaign,
        votingPower,
        page,
        filters,
        count,
        favoriteIds,
      ];

  VotingCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<VotingPower>? votingPower,
    Optional<Page<Proposal>>? page,
    ProposalsFilters? filters,
    ProposalsCount? count,
    Optional<List<String>>? favoriteIds,
  }) {
    return VotingCubitCache(
      campaign: campaign.dataOr(this.campaign),
      votingPower: votingPower.dataOr(this.votingPower),
      page: page.dataOr(this.page),
      filters: filters ?? this.filters,
      count: count ?? this.count,
      favoriteIds: favoriteIds?.dataOr(this.favoriteIds),
    );
  }
}
