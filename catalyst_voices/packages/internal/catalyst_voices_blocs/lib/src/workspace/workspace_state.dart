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

  const WorkspaceState({
    this.isLoading = false,
    this.error,
    this.userProposals = const WorkspaceStateUserProposals(),
    this.timelineItems = const [],
    this.fundNumber = 0,
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
  ];

  bool get showError => error != null && !isLoading;
  bool get showProposals => error == null;

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
  }) {
    return WorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      userProposals: userProposals ?? this.userProposals,
      timelineItems: timelineItems ?? this.timelineItems,
      fundNumber: fundNumber ?? this.fundNumber,
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
  final UserProposalsView published;
  final UserProposalsView notPublished;
  final bool hasComments;

  const WorkspaceStateUserProposals({
    this.localProposals = const UserProposalsView(),
    this.draftProposals = const UserProposalsView(),
    this.finalProposals = const UserProposalsView(),
    this.published = const UserProposalsView(),
    this.notPublished = const UserProposalsView(),
    this.hasComments = false,
  });

  factory WorkspaceStateUserProposals.fromList(List<UsersProposalOverview> proposals) {
    return WorkspaceStateUserProposals(
      localProposals: UserProposalsView(
        items: proposals.where((element) => element.publish == ProposalPublish.localDraft).toList(),
      ),
      draftProposals: UserProposalsView(
        items: proposals.where((e) => e.publish == ProposalPublish.publishedDraft).toList(),
      ),
      finalProposals: UserProposalsView(
        items: proposals.where((e) => e.publish == ProposalPublish.submittedProposal).toList(),
      ),
      published: UserProposalsView(
        items: proposals.where((e) => (e.publish.isPublished || e.publish.isDraft)).toList(),
      ),
      notPublished: UserProposalsView(
        items: proposals
            .where(
              (element) =>
                  element.versions.any((version) => version.isLatestLocal) ||
                  element.publish == ProposalPublish.localDraft,
            )
            .toList(),
      ),
      hasComments: proposals.any(
        (e) => e.commentsCount > 0,
      ),
    );
  }

  @override
  List<Object?> get props => [
    localProposals,
    draftProposals,
    finalProposals,
    published,
    notPublished,
    hasComments,
  ];
}
