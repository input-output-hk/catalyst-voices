import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final WorkspaceStateUserProposals userProposals;
  final List<CampaignTimelineViewModel> timelineItems;
  final int fundNumber;
  final int invitationsApprovalsCount;

  const WorkspaceState({
    this.isLoading = false,
    this.error,
    this.userProposals = const WorkspaceStateUserProposals(),
    this.timelineItems = const [],
    this.fundNumber = 0,
    this.invitationsApprovalsCount = 0,
  });

  WorkspaceStateCampaignTimeline get campaignTimeline =>
      WorkspaceStateCampaignTimeline._(items: timelineItems);

  @override
  List<Object?> get props => [
    isLoading,
    error,
    userProposals,
    timelineItems,
    fundNumber,
    invitationsApprovalsCount,
  ];

  bool get showProposals => error == null && !isLoading;

  DateTime? get submissionCloseDate => timelineItems
      .firstWhereOrNull(
        (e) => e.type == CampaignPhaseType.proposalSubmission,
      )
      ?.timeline
      .to;

  WorkspaceState copyWith({
    bool? isLoading,
    Optional<LocalizedException>? error,
    WorkspaceStateUserProposals? userProposals,
    List<CampaignTimelineViewModel>? timelineItems,
    int? fundNumber,
    int? invitationsApprovalsCount,
  }) {
    return WorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      userProposals: userProposals ?? this.userProposals,
      timelineItems: timelineItems ?? this.timelineItems,
      fundNumber: fundNumber ?? this.fundNumber,
      invitationsApprovalsCount: invitationsApprovalsCount ?? this.invitationsApprovalsCount,
    );
  }
}

final class WorkspaceStateCampaignTimeline extends Equatable {
  final List<CampaignTimelineViewModel> items;

  const WorkspaceStateCampaignTimeline._({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}

final class WorkspaceStateUserProposals extends Equatable {
  final UserProposalsView localProposals;
  final UserProposalsView draftProposals;
  final UserProposalsView finalProposals;
  final UserProposalsView inactiveProposals;
  final UserProposalsView published;
  final UserProposalsView notPublished;
  final bool hasComments;
  final WorkspaceFilters currentFilter;

  const WorkspaceStateUserProposals({
    this.localProposals = const UserProposalsView(),
    this.draftProposals = const UserProposalsView(),
    this.finalProposals = const UserProposalsView(),
    this.inactiveProposals = const UserProposalsView(),
    this.published = const UserProposalsView(),
    this.notPublished = const UserProposalsView(),
    this.hasComments = false,
    this.currentFilter = WorkspaceFilters.allProposals,
  });

  factory WorkspaceStateUserProposals.fromList(
    List<UsersProposalOverview> proposals,
    WorkspaceFilters filter,
  ) {
    // Single-pass filtering for better performance
    final localProposalsList = <UsersProposalOverview>[];
    final draftProposalsList = <UsersProposalOverview>[];
    final finalProposalsList = <UsersProposalOverview>[];
    final inactiveProposalsList = <UsersProposalOverview>[];
    final publishedList = <UsersProposalOverview>[];
    final notPublishedList = <UsersProposalOverview>[];
    var hasComments = false;

    for (final proposal in proposals) {
      if (!hasComments && proposal.commentsCount > 0) {
        hasComments = true;
      }

      // Inactive proposals (not from active campaign) go only to inactive list
      if (!proposal.fromActiveCampaign) {
        inactiveProposalsList.add(proposal);
        continue; // Skip adding to active campaign lists
      }

      // Only proposals from active campaign are added to the following lists
      switch (proposal.publish) {
        case ProposalPublish.localDraft:
          localProposalsList.add(proposal);
          notPublishedList.add(proposal);
        case ProposalPublish.publishedDraft:
          draftProposalsList.add(proposal);
          publishedList.add(proposal);
          // Check for newer local version
          if (proposal.versions.any((version) => version.isLatestLocal)) {
            notPublishedList.add(proposal);
          }
        case ProposalPublish.submittedProposal:
          finalProposalsList.add(proposal);
          publishedList.add(proposal);
          // Check for newer local version
          if (proposal.versions.any((version) => version.isLatestLocal)) {
            notPublishedList.add(proposal);
          }
      }
    }

    return WorkspaceStateUserProposals(
      localProposals: UserProposalsView(items: localProposalsList),
      draftProposals: UserProposalsView(items: draftProposalsList),
      finalProposals: UserProposalsView(items: finalProposalsList),
      inactiveProposals: UserProposalsView(items: inactiveProposalsList),
      published: UserProposalsView(items: publishedList),
      notPublished: UserProposalsView(items: notPublishedList),
      hasComments: hasComments,
      currentFilter: filter,
    );
  }

  @override
  List<Object?> get props => [
    localProposals,
    draftProposals,
    finalProposals,
    inactiveProposals,
    published,
    notPublished,
    hasComments,
    currentFilter,
  ];

  WorkspaceStateUserProposals copyWith({
    UserProposalsView? localProposals,
    UserProposalsView? draftProposals,
    UserProposalsView? finalProposals,
    UserProposalsView? inactiveProposals,
    UserProposalsView? published,
    UserProposalsView? notPublished,
    bool? hasComments,
    WorkspaceFilters? currentFilter,
  }) {
    return WorkspaceStateUserProposals(
      localProposals: localProposals ?? this.localProposals,
      draftProposals: draftProposals ?? this.draftProposals,
      finalProposals: finalProposals ?? this.finalProposals,
      inactiveProposals: inactiveProposals ?? this.inactiveProposals,
      published: published ?? this.published,
      notPublished: notPublished ?? this.notPublished,
      hasComments: hasComments ?? this.hasComments,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}
