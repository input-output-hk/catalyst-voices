import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingCubitCache extends Equatable {
  final Campaign? campaign;
  final VotingPower? votingPower;
  final Page<ProposalBrief>? page;
  final ProposalsFiltersV2 filters;
  final VotingPageTab? tab;
  final CatalystId? activeAccountId;

  const VotingCubitCache({
    this.campaign,
    this.votingPower,
    this.page,
    this.filters = const ProposalsFiltersV2(),
    this.tab,
    this.activeAccountId,
  });

  @override
  List<Object?> get props => [
    campaign,
    votingPower,
    page,
    filters,
    tab,
    activeAccountId,
  ];

  VotingCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<VotingPower>? votingPower,
    Optional<Page<ProposalBrief>>? page,
    ProposalsFiltersV2? filters,
    Optional<VotingPageTab>? tab,
    Optional<CatalystId>? activeAccountId,
  }) {
    return VotingCubitCache(
      campaign: campaign.dataOr(this.campaign),
      votingPower: votingPower.dataOr(this.votingPower),
      page: page.dataOr(this.page),
      filters: filters ?? this.filters,
      tab: tab.dataOr(this.tab),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
    );
  }
}
