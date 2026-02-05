import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class MyActionsCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final AccountVotingRole? accountVotingRole;
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final DateTime? becomeReviewerCloseDate;
  final DateTime? votingSnapshotDate;
  final ActionsPageTab selectedTab;

  const MyActionsCubitCache({
    this.activeAccountId,
    this.accountVotingRole,
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.becomeReviewerCloseDate,
    this.votingSnapshotDate,
    this.selectedTab = ActionsPageTab.all,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    accountVotingRole,
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    becomeReviewerCloseDate,
    votingSnapshotDate,
    selectedTab,
  ];

  MyActionsCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<AccountVotingRole>? accountVotingRole,
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    Optional<DateTime>? becomeReviewerCloseDate,
    Optional<DateTime>? votingSnapshotDate,
    ActionsPageTab? selectedTab,
    Set<AccountRole>? accountRoles,
  }) {
    return MyActionsCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      accountVotingRole: accountVotingRole.dataOr(this.accountVotingRole),
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
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
