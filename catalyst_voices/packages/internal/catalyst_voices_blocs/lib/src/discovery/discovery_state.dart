part of 'discovery_cubit.dart';

final class DiscoveryCampaignCategoriesState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<CampaignCategoryDetailsViewModel> categories;

  const DiscoveryCampaignCategoriesState({
    this.isLoading = true,
    this.error,
    this.categories = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
        categories,
      ];

  bool get showCategories =>
      !isLoading && categories.isNotEmpty && error == null;

  bool get showError => !isLoading && error != null;
}

final class DiscoveryCurrentCampaignState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final CurrentCampaignInfoViewModel currentCampaign;
  final List<CampaignTimeline> campaignTimeline;

  const DiscoveryCurrentCampaignState({
    this.isLoading = true,
    this.error,
    CurrentCampaignInfoViewModel? currentCampaign,
    this.campaignTimeline = const [],
  }) : currentCampaign =
            currentCampaign ?? const NullCurrentCampaignInfoViewModel();

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentCampaign,
        campaignTimeline,
      ];

  bool get showCurrentCampaign =>
      !isLoading && currentCampaign is! NullCurrentCampaignInfoViewModel;

  bool get showError => !isLoading && error != null;

  DateTime? get votingStartsAt {
    return campaignTimeline
        .firstWhere((e) => e.stage == CampaignTimelineStage.communityVoting)
        .timeline
        .from;
  }
}

final class DiscoveryMostRecentProposalsState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<PendingProposal> proposals;

  const DiscoveryMostRecentProposalsState({
    this.isLoading = true,
    this.error,
    this.proposals = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
        proposals,
      ];

  bool get showError => !isLoading && error != null;

  bool get showProposals => !isLoading && proposals.isNotEmpty && error == null;

  DiscoveryMostRecentProposalsState copyWith({
    bool? isLoading,
    LocalizedException? error,
    List<PendingProposal>? proposals,
  }) {
    return DiscoveryMostRecentProposalsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      proposals: proposals ?? this.proposals,
    );
  }
}

final class DiscoveryState extends Equatable {
  final DiscoveryCurrentCampaignState currentCampaign;
  final DiscoveryCampaignCategoriesState campaignCategories;
  final DiscoveryMostRecentProposalsState mostRecentProposals;

  const DiscoveryState({
    this.currentCampaign = const DiscoveryCurrentCampaignState(),
    this.campaignCategories = const DiscoveryCampaignCategoriesState(),
    this.mostRecentProposals = const DiscoveryMostRecentProposalsState(),
  });

  @override
  List<Object?> get props => [
        currentCampaign,
        campaignCategories,
        mostRecentProposals,
      ];

  DiscoveryState copyWith({
    DiscoveryCurrentCampaignState? currentCampaign,
    DiscoveryCampaignCategoriesState? campaignCategories,
    DiscoveryMostRecentProposalsState? mostRecentProposals,
  }) {
    return DiscoveryState(
      currentCampaign: currentCampaign ?? this.currentCampaign,
      campaignCategories: campaignCategories ?? this.campaignCategories,
      mostRecentProposals: mostRecentProposals ?? this.mostRecentProposals,
    );
  }
}
