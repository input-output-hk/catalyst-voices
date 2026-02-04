import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Matches proposals where [id] is a collaborator with a specific [status].
/// If [status] is null, matches all collaboration invitations regardless of status.
final class CollaborationInvitation extends ProposalsRelationship {
  final CatalystId id;
  final CollaborationInvitationStatus? status;

  const CollaborationInvitation({
    required this.id,
    required this.status,
  });

  const CollaborationInvitation.accepted(this.id) : status = CollaborationInvitationStatus.accepted;

  const CollaborationInvitation.any(this.id) : status = null;

  const CollaborationInvitation.pending(this.id) : status = CollaborationInvitationStatus.pending;

  const CollaborationInvitation.rejected(this.id) : status = CollaborationInvitationStatus.rejected;

  @override
  List<Object?> get props => [id, status];

  @override
  String toString() =>
      status != null ? 'Collaborator($id, status: $status)' : 'Collaborator($id, status: any)';
}

/// Defines the status of a collaborator's relationship with a proposal.
///
/// Invitation status is different from accepting proposal version, where `final` proposal
/// is treated differently.
enum CollaborationInvitationStatus {
  /// The user has accepted the invitation by submitting a 'draft' or 'final' action.
  accepted,

  /// The user has rejected the invitation by submitting a 'hide' action.
  rejected,

  /// The user is listed as a collaborator but has not submitted any action yet.
  pending,
}

/// Matches proposals where [id] is the signer of the first version (id == ver).
final class OriginalAuthor extends ProposalsRelationship {
  final CatalystId id;

  const OriginalAuthor(this.id);

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'OriginalAuthor($id)';
}

/// Defines the specific relationship criteria for filtering proposals.
sealed class ProposalsRelationship extends Equatable {
  const ProposalsRelationship();

  @override
  List<Object?> get props => [];
}
