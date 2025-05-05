import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

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

  DiscoveryMostRecentProposalsState updateFavorites(List<String> ids) {
    final updatedProposals = [...proposals]
        .map((e) => e.copyWith(isFavorite: ids.contains(e.ref.id)))
        .toList();

    return copyWith(proposals: updatedProposals);
  }
}

final class DiscoveryState extends Equatable {
  final DiscoveryCurrentCampaignState campaign;
  final DiscoveryCampaignCategoriesState categories;
  final DiscoveryMostRecentProposalsState proposals;

  const DiscoveryState({
    this.campaign = const DiscoveryCurrentCampaignState(),
    this.categories = const DiscoveryCampaignCategoriesState(),
    this.proposals = const DiscoveryMostRecentProposalsState(),
  });

  @override
  List<Object?> get props => [
        campaign,
        categories,
        proposals,
      ];

  DiscoveryState copyWith({
    DiscoveryCurrentCampaignState? campaign,
    DiscoveryCampaignCategoriesState? categories,
    DiscoveryMostRecentProposalsState? proposals,
  }) {
    return DiscoveryState(
      campaign: campaign ?? this.campaign,
      categories: categories ?? this.categories,
      proposals: proposals ?? this.proposals,
    );
  }
}
