import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CampaignDatesEventsState extends Equatable {
  final List<CampaignTimelineEventWithTitle> reviewTimelineItems;
  final List<CampaignTimelineEventWithTitle> votingTimelineItems;

  const CampaignDatesEventsState({
    this.reviewTimelineItems = const [],
    this.votingTimelineItems = const [],
  });

  @override
  List<Object?> get props => [
    reviewTimelineItems,
    votingTimelineItems,
  ];
}

final class DiscoveryCampaignState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final CurrentCampaignInfoViewModel? currentCampaign;
  final List<CampaignTimelineViewModel> campaignTimeline;
  final List<CampaignCategoryDetailsViewModel> categories;
  final CampaignDatesEventsState datesEvents;

  const DiscoveryCampaignState({
    this.isLoading = false,
    this.error,
    this.currentCampaign,
    this.campaignTimeline = const [],
    this.categories = const [],
    this.datesEvents = const CampaignDatesEventsState(),
  });

  @override
  List<Object?> get props => [
    isLoading,
    error,
    currentCampaign,
    campaignTimeline,
    categories,
    datesEvents,
  ];

  bool get showError => !isLoading && error != null;

  DiscoveryCampaignState copyWith({
    bool? isLoading,
    LocalizedException? error,
    Optional<CurrentCampaignInfoViewModel>? currentCampaign,
    List<CampaignTimelineViewModel>? campaignTimeline,
    List<CampaignCategoryDetailsViewModel>? categories,
    CampaignDatesEventsState? datesEvents,
  }) {
    return DiscoveryCampaignState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentCampaign: currentCampaign.dataOr(this.currentCampaign),
      campaignTimeline: campaignTimeline ?? this.campaignTimeline,
      categories: categories ?? this.categories,
      datesEvents: datesEvents ?? this.datesEvents,
    );
  }
}

final class DiscoveryMostRecentProposalsState extends Equatable {
  final List<ProposalBrief> proposals;
  final bool showSection;

  const DiscoveryMostRecentProposalsState({
    this.proposals = const [],
    this.showSection = false,
  });

  @override
  List<Object?> get props => [
    proposals,
    showSection,
  ];

  DiscoveryMostRecentProposalsState copyWith({
    List<ProposalBrief>? proposals,
    bool? showSection,
  }) {
    return DiscoveryMostRecentProposalsState(
      proposals: proposals ?? this.proposals,
      showSection: showSection ?? this.showSection,
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
