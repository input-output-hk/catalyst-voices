part of 'discovery_cubit.dart';

final class DiscoveryState extends Equatable {
  final DiscoveryCurrentCampaignState currentCampaign;
  final DiscoveryCampaignCategoriesState campaignCategories;

  const DiscoveryState({
    this.currentCampaign = const DiscoveryCurrentCampaignState(),
    this.campaignCategories = const DiscoveryCampaignCategoriesState(),
  });

  DiscoveryState copyWith({
    DiscoveryCurrentCampaignState? currentCampaign,
    DiscoveryCampaignCategoriesState? campaignCategories,
  }) {
    return DiscoveryState(
      currentCampaign: currentCampaign ?? this.currentCampaign,
      campaignCategories: campaignCategories ?? this.campaignCategories,
    );
  }

  @override
  List<Object?> get props => [
        currentCampaign,
        campaignCategories,
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
  final List<CampaignCategoryCardViewModel> categories;

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
