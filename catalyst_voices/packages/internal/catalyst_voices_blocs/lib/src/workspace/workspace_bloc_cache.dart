import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Cache for [WorkspaceBloc].
final class WorkspaceBlocCache extends Equatable {
  final Campaign? campaign;
  final CatalystId? activeAccountId;
  final ProposalsFiltersV2 proposalsFilters;
  final WorkspaceFilters workspaceFilter;
  final List<CampaignCategory>? categories;
  final List<UsersProposalOverview>? proposals;
  final List<UsersProposalOverview>? userProposalInvites;

  const WorkspaceBlocCache({
    this.campaign,
    this.activeAccountId,
    this.workspaceFilter = WorkspaceFilters.allProposals,
    this.proposalsFilters = const ProposalsFiltersV2(),
    this.categories,
    this.proposals,
    this.userProposalInvites,
  });

  @override
  List<Object?> get props => [
    campaign,
    activeAccountId,
    workspaceFilter,
    proposalsFilters,
    categories,
    proposals,
    userProposalInvites,
  ];

  WorkspaceBlocCache copyWith({
    Optional<Campaign>? campaign,
    Optional<CatalystId>? activeAccountId,
    ProposalsFiltersV2? proposalsFilters,
    WorkspaceFilters? workspaceFilter,
    Optional<List<CampaignCategory>>? categories,
    Optional<List<UsersProposalOverview>>? proposals,
    Optional<List<UsersProposalOverview>>? userProposalInvites,
  }) {
    return WorkspaceBlocCache(
      campaign: campaign.dataOr(this.campaign),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      proposalsFilters: proposalsFilters ?? this.proposalsFilters,
      workspaceFilter: workspaceFilter ?? this.workspaceFilter,
      categories: categories.dataOr(this.categories),
      proposals: proposals.dataOr(this.proposals),
      userProposalInvites: userProposalInvites.dataOr(this.userProposalInvites),
    );
  }
}
