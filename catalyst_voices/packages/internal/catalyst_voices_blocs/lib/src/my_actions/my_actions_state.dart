import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class MyActionsState extends Equatable {
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final DateTime? becomeReviewerCloseDate;
  final List<ActionsCardType> availableCards;

  const MyActionsState({
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.becomeReviewerCloseDate,
    this.availableCards = const [],
  });

  @override
  List<Object?> get props => [
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    becomeReviewerCloseDate,
    availableCards,
  ];

  MyActionsState copyWith({
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    Optional<DateTime>? becomeReviewerCloseDate,
    List<ActionsCardType>? availableCards,
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
      availableCards: availableCards ?? this.availableCards,
    );
  }
}
