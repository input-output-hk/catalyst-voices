import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<UsersProposalOverview> userProposals;
  final List<CampaignTimelineViewModel> timelineItems;

  const WorkspaceState({
    this.isLoading = false,
    this.error,
    this.userProposals = const [],
    this.timelineItems = const [],
  });

  bool get hasComments => userProposals.any((e) => e.commentsCount > 0);

  List<UsersProposalOverview> get notPublished => userProposals
      .where(
        (element) =>
            element.versions.any((version) => version.isLatestLocal) ||
            element.publish == ProposalPublish.localDraft,
      )
      .toList();

  @override
  List<Object?> get props => [
        isLoading,
        error,
        userProposals,
        timelineItems,
      ];

  List<UsersProposalOverview> get published =>
      userProposals.where((e) => (e.publish.isPublished || e.publish.isDraft)).toList();

  bool get showError => error != null && !isLoading;
  bool get showProposals => error == null;

  DateTime? get submissionCloseDate => timelineItems
      .firstWhereOrNull(
        (e) => e.stage == CampaignTimelineStage.proposalSubmission,
      )
      ?.timeline
      .to;

  int get totalPublishedProposals => published.length;

  WorkspaceState copyWith({
    bool? isLoading,
    Optional<LocalizedException>? error,
    List<UsersProposalOverview>? userProposals,
    List<CampaignTimelineViewModel>? timelineItems,
  }) {
    return WorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      userProposals: userProposals ?? this.userProposals,
      timelineItems: timelineItems ?? this.timelineItems,
    );
  }
}
