import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class MyActionsCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final DateTime? becomeReviewerCloseDate;
  final ActionsPageTab selectedTab;
  final Set<AccountRole> accountRoles;

  const MyActionsCubitCache({
    this.activeAccountId,
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.becomeReviewerCloseDate,
    this.selectedTab = ActionsPageTab.all,
    this.accountRoles = const {},
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    becomeReviewerCloseDate,
    selectedTab,
    accountRoles,
  ];

  MyActionsCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    Optional<DateTime>? becomeReviewerCloseDate,
    ActionsPageTab? selectedTab,
    Set<AccountRole>? accountRoles,
  }) {
    return MyActionsCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      displayConsentCount: displayConsentCount ?? this.displayConsentCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      proposalSubmissionCloseDate: proposalSubmissionCloseDate.dataOr(
        this.proposalSubmissionCloseDate,
      ),
      becomeReviewerCloseDate: becomeReviewerCloseDate.dataOr(
        this.becomeReviewerCloseDate,
      ),
      selectedTab: selectedTab ?? this.selectedTab,
      accountRoles: accountRoles ?? this.accountRoles,
    );
  }
}
