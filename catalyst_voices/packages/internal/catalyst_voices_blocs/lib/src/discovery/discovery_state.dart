import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class CampaignDatesEventsState extends Equatable {
  final DateRange? reviewRegistrationStartsAt;
  final DateRange? reviewStartsAt;
  final DateRange? votingRegistrationStartsAt;
  final DateRange? votingStartsAt;

  factory CampaignDatesEventsState.fromTimeline(List<CampaignTimelineViewModel> campaignTimeline) {
    return CampaignDatesEventsState._(
      reviewRegistrationStartsAt: campaignTimeline
          .firstWhereOrNull((e) => e.type == CampaignPhaseType.reviewRegistration)
          ?.timeline,
      reviewStartsAt: campaignTimeline
          .firstWhereOrNull((e) => e.type == CampaignPhaseType.communityReview)
          ?.timeline,
      votingRegistrationStartsAt: campaignTimeline
          .firstWhereOrNull((e) => e.type == CampaignPhaseType.votingRegistration)
          ?.timeline,
      votingStartsAt: campaignTimeline
          .firstWhereOrNull((e) => e.type == CampaignPhaseType.communityVoting)
          ?.timeline,
    );
  }

  const CampaignDatesEventsState._({
    required this.reviewRegistrationStartsAt,
    required this.reviewStartsAt,
    required this.votingRegistrationStartsAt,
    required this.votingStartsAt,
  });

  @override
  List<Object?> get props => [
    reviewRegistrationStartsAt,
    reviewStartsAt,
    votingRegistrationStartsAt,
    votingStartsAt,
  ];
}

final class DiscoveryCampaignState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final CurrentCampaignInfoViewModel currentCampaign;
  final List<CampaignTimelineViewModel> campaignTimeline;
  final List<CampaignCategoryDetailsViewModel> categories;

  const DiscoveryCampaignState({
    this.isLoading = true,
    this.error,
    CurrentCampaignInfoViewModel? currentCampaign,
    this.campaignTimeline = const [],
    this.categories = const [],
  }) : currentCampaign = currentCampaign ?? const NullCurrentCampaignInfoViewModel();

  CampaignDatesEventsState get datesEvents =>
      CampaignDatesEventsState.fromTimeline(campaignTimeline);

  @override
  List<Object?> get props => [
    isLoading,
    error,
    currentCampaign,
    campaignTimeline,
    categories,
  ];

  bool get showError => !isLoading && error != null;

  DiscoveryCampaignState copyWith({
    bool? isLoading,
    LocalizedException? error,
    CurrentCampaignInfoViewModel? currentCampaign,
    List<CampaignTimelineViewModel>? campaignTimeline,
    List<CampaignCategoryDetailsViewModel>? categories,
  }) {
    return DiscoveryCampaignState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentCampaign: currentCampaign ?? this.currentCampaign,
      campaignTimeline: campaignTimeline ?? this.campaignTimeline,
      categories: categories ?? this.categories,
    );
  }
}

final class DiscoveryMostRecentProposalsState extends Equatable {
  final LocalizedException? error;
  final List<ProposalBrief> proposals;
  final List<String> favoritesIds;
  final bool showComments;

  const DiscoveryMostRecentProposalsState({
    this.error,
    this.proposals = const [],
    this.favoritesIds = const [],
    this.showComments = false,
  });

  @override
  List<Object?> get props => [
    error,
    proposals,
    favoritesIds,
    showComments,
  ];

  bool get showError => error != null;

  DiscoveryMostRecentProposalsState copyWith({
    bool? isLoading,
    LocalizedException? error,
    List<ProposalBrief>? proposals,
    List<String>? favoritesIds,
    bool? showComments,
  }) {
    return DiscoveryMostRecentProposalsState(
      error: error ?? this.error,
      proposals: proposals ?? this.proposals,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      showComments: showComments ?? this.showComments,
    );
  }

  DiscoveryMostRecentProposalsState updateFavorites(List<String> ids) {
    final updatedProposals = [
      ...proposals,
    ].map((e) => e.copyWith(isFavorite: ids.contains(e.selfRef.id))).toList();

    return copyWith(
      proposals: updatedProposals,
      favoritesIds: ids,
    );
  }
}

final class DiscoveryState extends Equatable {
  final DiscoveryCampaignState campaign;
  final DiscoveryMostRecentProposalsState proposals;

  const DiscoveryState({
    this.campaign = const DiscoveryCampaignState(),
    this.proposals = const DiscoveryMostRecentProposalsState(),
  });

  @override
  List<Object?> get props => [
    campaign,
    proposals,
  ];

  DiscoveryState copyWith({
    DiscoveryCampaignState? campaign,
    DiscoveryMostRecentProposalsState? proposals,
  }) {
    return DiscoveryState(
      campaign: campaign ?? this.campaign,
      proposals: proposals ?? this.proposals,
    );
  }
}
