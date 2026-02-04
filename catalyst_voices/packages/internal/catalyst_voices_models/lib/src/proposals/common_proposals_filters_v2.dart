import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';

// TODO(damian-molinski): should filter by campaign
final class CollaboratorInvitationsProposalsFilter extends ProposalsFiltersV2 {
  CollaboratorInvitationsProposalsFilter(CatalystId id)
    : super(
        status: ProposalStatusFilter.draft,
        relationships: {
          CollaborationInvitation.pending(id),
        },
      );
}

// TODO(damian-molinski): should filter by campaign
final class CollaboratorProposalApprovalsFilter extends ProposalsFiltersV2 {
  CollaboratorProposalApprovalsFilter(
    CatalystId id, {
    ProposalApprovalStatus approvalStatus = ProposalApprovalStatus.any,
  }) : super(
         status: ProposalStatusFilter.aFinal,
         relationships: approvalStatus.approvalFilter(id),
       );
}

// TODO(damian-molinski): should filter by campaign
final class CollaboratorProposalDisplayConsentFilter extends ProposalsFiltersV2 {
  CollaboratorProposalDisplayConsentFilter(CatalystId id)
    : super(
        relationships: {
          CollaborationInvitation.any(id),
        },
      );
}
