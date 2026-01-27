import 'package:catalyst_voices_models/catalyst_voices_models.dart';

enum ProposalApprovalStatus {
  decide,
  aFinal,
  any;

  Set<CollaborationInvitation> approvalFilter(CatalystId id) {
    return switch (this) {
      decide => {
        CollaborationInvitation.pending(id),
      },
      aFinal => {
        CollaborationInvitation.accepted(id),
        CollaborationInvitation.rejected(id),
      },
      any => {
        CollaborationInvitation.any(id),
      },
    };
  }
}
