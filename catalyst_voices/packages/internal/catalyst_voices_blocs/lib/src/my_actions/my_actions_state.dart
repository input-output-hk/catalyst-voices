import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ActionCardsState extends Equatable {
  final List<ActionsCardType> availableCards;
  final ActionsPageTab selectedTab;

  const ActionCardsState({
    this.availableCards = const [],
    this.selectedTab = ActionsPageTab.all,
  });

  @override
  List<Object?> get props => [availableCards, selectedTab];

  ActionCardsState copyWith({
    List<ActionsCardType>? availableCards,
    ActionsPageTab? selectedTab,
  }) {
    return ActionCardsState(
      availableCards: availableCards ?? this.availableCards,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

final class MyActionsState extends Equatable {
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final DateTime? becomeReviewerCloseDate;
  final DateTime? votingSnapshotDate;
  final ActionCardsState actionCardsState;

  const MyActionsState({
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.becomeReviewerCloseDate,
    this.votingSnapshotDate,
    this.actionCardsState = const ActionCardsState(),
  });

  @override
  List<Object?> get props => [
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    becomeReviewerCloseDate,
    votingSnapshotDate,
    actionCardsState,
  ];

  MyActionsState copyWith({
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    Optional<DateTime>? becomeReviewerCloseDate,
    Optional<DateTime>? votingSnapshotDate,
    ActionCardsState? actionCardsState,
  }) {
    return MyActionsState(
      displayConsentCount: displayConsentCount ?? this.displayConsentCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      proposalSubmissionCloseDate: proposalSubmissionCloseDate.dataOr(
        this.proposalSubmissionCloseDate,
      ),
      becomeReviewerCloseDate: becomeReviewerCloseDate.dataOr(
        this.becomeReviewerCloseDate,
      ),
      votingSnapshotDate: votingSnapshotDate.dataOr(
        this.votingSnapshotDate,
      ),
      actionCardsState: actionCardsState ?? this.actionCardsState,
    );
  }
}
