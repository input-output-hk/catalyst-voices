import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AcceptedCollaboratorInvites extends CollaboratorInvitesState {
  const AcceptedCollaboratorInvites(super.invites);
}

final class AllCollaboratorInvites extends CollaboratorInvitesState {
  const AllCollaboratorInvites(super.invites);
}

final class CollaboratorInvite extends Equatable {
  final CatalystId catalystId;
  final CollaboratorInviteStatus status;

  const CollaboratorInvite({
    required this.catalystId,
    required this.status,
  });

  @override
  List<Object?> get props => [catalystId, status];
}

sealed class CollaboratorInvitesState extends Equatable {
  final List<CollaboratorInvite> invites;

  const CollaboratorInvitesState([this.invites = const []]);

  /// Filters collaborator invites by [activeAccountId].
  /// - Returns all [collaborators] if [activeAccountId] is [authorId] or one of [collaborators].
  /// - Returns collaborators with [CollaboratorInviteStatus.accepted] status otherwise.
  factory CollaboratorInvitesState.filterByActiveAccount({
    required CatalystId? activeAccountId,
    required CatalystId? authorId,
    required List<CollaboratorInvite> collaborators,
  }) {
    if (activeAccountId != null && authorId != null && activeAccountId.isSame(authorId)) {
      return AllCollaboratorInvites(collaborators);
    }

    if (activeAccountId != null && collaborators.any((e) => e.catalystId.isSame(activeAccountId))) {
      return AllCollaboratorInvites(collaborators);
    }

    return AcceptedCollaboratorInvites(
      collaborators.where((e) => e.status == CollaboratorInviteStatus.accepted).toList(),
    );
  }

  @override
  List<Object?> get props => [invites];
}

/// A state of the collaborator invited to a document (proposal).
enum CollaboratorInviteStatus {
  /// The invitation is pending, the collaborator needs to accept / reject.
  pending,

  /// The invitation is accepted by the collaborator.
  accepted,

  /// The invitation is rejected by the collaborator.
  rejected,

  /// The collaborator has accepted and then left.
  left,

  /// The collaborator has been removed.
  removed,
}
