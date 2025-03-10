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

  const DiscoveryCurrentCampaignState({
    this.isLoading = true,
    this.error,
    CurrentCampaignInfoViewModel? currentCampaign,
  }) : currentCampaign =
            currentCampaign ?? const NullCurrentCampaignInfoViewModel();

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentCampaign,
      ];

  bool get showCurrentCampaign =>
      !isLoading && currentCampaign is! NullCurrentCampaignInfoViewModel;

  bool get showError => !isLoading && error != null;
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
