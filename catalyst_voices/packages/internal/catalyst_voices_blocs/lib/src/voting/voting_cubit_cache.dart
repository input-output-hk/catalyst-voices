import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingCubitCache extends Equatable {
  final Campaign? campaign;
  final AccountVotingRole? votingRole;
  final Page<ProposalBrief>? page;
  final ProposalsFiltersV2 filters;
  final VotingPageTab? tab;
  final CatalystId? activeAccountId;

  const VotingCubitCache({
    this.campaign,
    this.votingRole,
    this.page,
    this.filters = const ProposalsFiltersV2(),
    this.tab,
    this.activeAccountId,
  });

  @override
  List<Object?> get props => [
    campaign,
    votingRole,
    page,
    filters,
    tab,
    activeAccountId,
  ];

  VotingCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<AccountVotingRole>? votingRole,
    Optional<Page<ProposalBrief>>? page,
    ProposalsFiltersV2? filters,
    Optional<VotingPageTab>? tab,
    Optional<CatalystId>? activeAccountId,
  }) {
    return VotingCubitCache(
      campaign: campaign.dataOr(this.campaign),
      votingRole: votingRole.dataOr(this.votingRole),
      page: page.dataOr(this.page),
      filters: filters ?? this.filters,
      tab: tab.dataOr(this.tab),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
    );
  }
}
