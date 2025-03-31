import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<Proposal> userProposals;
  final List<CampaignTimelineViewModel> timelineItems;

  const WorkspaceState({
    this.isLoading = false,
    this.error,
    this.userProposals = const [],
    this.timelineItems = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
        userProposals,
        timelineItems,
      ];

  bool get showError => error != null && !isLoading;
  bool get showLoading => isLoading;
  bool get showProposals => error == null && !isLoading;
  DateTime? get submittionCloseDate => timelineItems
      .firstWhereOrNull(
        (e) => e.stage == CampaignTimelineStage.proposalSubmission,
      )
      ?.timeline
      .to;

  WorkspaceState copyWith({
    WorkspaceTabType? tab,
    bool? isLoading,
    int? draftProposalCount,
    int? finalProposalCount,
    String? searchQuery,
    List<WorkspaceProposalListItem>? proposals,
    Optional<LocalizedException>? error,
    List<Proposal>? userProposals,
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
