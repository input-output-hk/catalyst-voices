import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceCubitCache extends Equatable {
  final Campaign? campaign;
  final CatalystId? activeAccountId;
  final WorkspacePageTab? activeTab;
  final ProposalsFiltersV2 proposalsFilters;
  final WorkspaceFilters workspaceFilter;
  final List<CampaignCategory>? categories;
  final List<UsersProposalOverview>? proposals;
  final List<UsersProposalOverview>? userProposalInvites;

  const WorkspaceCubitCache({
    this.campaign,
    this.activeAccountId,
    this.activeTab,
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
    activeTab,
    workspaceFilter,
    proposalsFilters,
    categories,
    proposals,
    userProposalInvites,
  ];

  WorkspaceCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<CatalystId>? activeAccountId,
    Optional<WorkspacePageTab>? activeTab,
    ProposalsFiltersV2? proposalsFilters,
    WorkspaceFilters? workspaceFilter,
    Optional<List<CampaignCategory>>? categories,
    Optional<List<UsersProposalOverview>>? proposals,
    Optional<List<UsersProposalOverview>>? userProposalInvites,
  }) {
    return WorkspaceCubitCache(
      campaign: campaign.dataOr(this.campaign),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      activeTab: activeTab.dataOr(this.activeTab),
      proposalsFilters: proposalsFilters ?? this.proposalsFilters,
      workspaceFilter: workspaceFilter ?? this.workspaceFilter,
      categories: categories.dataOr(this.categories),
      proposals: proposals.dataOr(this.proposals),
      userProposalInvites: userProposalInvites.dataOr(this.userProposalInvites),
    );
  }
}
