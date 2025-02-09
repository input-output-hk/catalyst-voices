part of 'discovery_cubit.dart';

final class DiscoveryState extends Equatable {
  final DiscoveryCurrentCampaignState currentCampaign;
  final DiscoveryCampaignCategoriesState campaignCategories;
  final DiscoveryMostRecentProposalsState mostRecentProposals;

  const DiscoveryState({
    this.currentCampaign = const DiscoveryCurrentCampaignState(),
    this.campaignCategories = const DiscoveryCampaignCategoriesState(),
    this.mostRecentProposals = const DiscoveryMostRecentProposalsState(),
  });

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

  @override
  List<Object?> get props => [
        currentCampaign,
        campaignCategories,
        mostRecentProposals,
      ];
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

  bool get showCurrentCampaign =>
      !isLoading && currentCampaign is! NullCurrentCampaignInfoViewModel;

  bool get showError => !isLoading && error != null;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        currentCampaign,
      ];
}

final class DiscoveryCampaignCategoriesState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<CampaignCategoryViewModel> categories;

  const DiscoveryCampaignCategoriesState({
    this.isLoading = true,
    this.error,
    this.categories = const [],
  });

  bool get showCategories =>
      !isLoading && categories.isNotEmpty && error == null;

  bool get showError => !isLoading && error != null;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        categories,
      ];
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

  bool get showProposals => !isLoading && proposals.isNotEmpty && error == null;

  bool get showError => !isLoading && error != null;

  @override
  List<Object?> get props => [
        isLoading,
        error,
        proposals,
      ];
}
