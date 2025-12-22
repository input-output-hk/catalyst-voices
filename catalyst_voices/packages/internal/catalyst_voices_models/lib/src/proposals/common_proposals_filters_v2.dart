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
  CollaboratorProposalApprovalsFilter(CatalystId id)
    : super(
        status: ProposalStatusFilter.aFinal,
        relationships: {
          // TODO(LynxLynxx): make CollaborationInvitationStatus in this class nullable so there could
          // be factory constructor .any() CC: (damian-molinski)
          CollaborationInvitation.pending(id),
          CollaborationInvitation.accepted(id),
          CollaborationInvitation.rejected(id),
        },
      );
}
