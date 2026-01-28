import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class MyActionsCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final DocumentRef? activeCampaignId;
  final AccountVotingRole? accountVotingRole;
  final int displayConsentCount;
  final int finalProposalCount;
  final DateTime? proposalSubmissionCloseDate;
  final DateTime? becomeReviewerCloseDate;
  final ActionsPageTab selectedTab;

  const MyActionsCubitCache({
    this.activeAccountId,
    this.activeCampaignId,
    this.accountVotingRole,
    this.displayConsentCount = 0,
    this.finalProposalCount = 0,
    this.proposalSubmissionCloseDate,
    this.becomeReviewerCloseDate,
    this.selectedTab = ActionsPageTab.all,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    activeCampaignId,
    accountVotingRole,
    displayConsentCount,
    finalProposalCount,
    proposalSubmissionCloseDate,
    becomeReviewerCloseDate,
    selectedTab,
  ];

  MyActionsCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<DocumentRef>? activeCampaignId,
    Optional<AccountVotingRole>? accountVotingRole,
    int? displayConsentCount,
    int? finalProposalCount,
    Optional<DateTime>? proposalSubmissionCloseDate,
    Optional<DateTime>? becomeReviewerCloseDate,
    ActionsPageTab? selectedTab,
    Set<AccountRole>? accountRoles,
  }) {
    return MyActionsCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      activeCampaignId: activeCampaignId.dataOr(this.activeCampaignId),
      accountVotingRole: accountVotingRole.dataOr(this.accountVotingRole),
      displayConsentCount: displayConsentCount ?? this.displayConsentCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      proposalSubmissionCloseDate: proposalSubmissionCloseDate.dataOr(
        this.proposalSubmissionCloseDate,
      ),
      becomeReviewerCloseDate: becomeReviewerCloseDate.dataOr(
        this.becomeReviewerCloseDate,
      ),
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
