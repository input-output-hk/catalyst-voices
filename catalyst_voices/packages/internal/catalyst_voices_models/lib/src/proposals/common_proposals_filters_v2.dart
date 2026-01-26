import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

final class CollaboratorInvitationsProposalsFilter extends ProposalsFiltersV2 {
  CollaboratorInvitationsProposalsFilter(CatalystId id)
    : super(
        status: ProposalStatusFilter.draft,
        relationships: {
          CollaborationInvitation.pending(id),
        },
      );
}

final class CollaboratorProposalApprovalsFilter extends ProposalsFiltersV2 {
  final ProposalApprovalStatus approvalStatus;

  CollaboratorProposalApprovalsFilter(
    CatalystId id, {
    this.approvalStatus = ProposalApprovalStatus.any,
  }) : super(
         status: ProposalStatusFilter.aFinal,
         relationships: approvalStatus.approvalFilter(id),
       );
}

final class CollaboratorProposalDisplayConsentFilter extends ProposalsFiltersV2 {
  CollaboratorProposalDisplayConsentFilter(CatalystId id)
    : super(
        relationships: {
          CollaborationInvitation.any(id),
        },
      );
}
