import 'package:catalyst_voices_models/catalyst_voices_models.dart';

enum ProposalApprovalStatus {
  decide,
  aFinal,
  any;

  Set<CollaborationInvitation> approvalFilter(
    CatalystId id, {
    required bool isPinned,
  }) {
    return switch (this) {
      decide => {
        CollaborationInvitation.pending(id, isPinned: isPinned),
      },
      aFinal => {
        CollaborationInvitation.accepted(id, isPinned: isPinned),
        CollaborationInvitation.rejected(id, isPinned: isPinned),
      },
      any => {
        CollaborationInvitation.any(id, isPinned: isPinned),
      },
    };
  }
}
