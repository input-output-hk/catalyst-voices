import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class MyActionsCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final ActionsPageTab selectedTab;

  const MyActionsCubitCache({
    this.activeAccountId,
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.selectedTab = ActionsPageTab.all,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    selectedTab,
  ];

  MyActionsCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    ActionsPageTab? selectedTab,
  }) {
    return MyActionsCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      displayConsentCount: displayConsentCount ?? this.displayConsentCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      proposalSubmissionCloseDate: proposalSubmissionCloseDate.dataOr(
        this.proposalSubmissionCloseDate,
      ),
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
