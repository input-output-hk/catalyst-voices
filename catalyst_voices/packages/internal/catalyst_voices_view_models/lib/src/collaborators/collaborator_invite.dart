import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AcceptedCollaboratorInvites extends CollaboratorInvites {
  const AcceptedCollaboratorInvites(super.invites);
}

final class AllCollaboratorInvites extends CollaboratorInvites {
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

sealed class CollaboratorInvites extends Equatable {
  final List<CollaboratorInvite> invites;

  const CollaboratorInvites([this.invites = const []]);

  /// Filters collaborator invites by [activeAccountId].
  /// - Returns all [collaborators] if [activeAccountId] is [authorId] or one of [collaborators].
  /// - Returns collaborators with [CollaboratorInviteStatus.accepted] status otherwise.
  factory CollaboratorInvites.filterByActiveAccount({
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
  pending,
  accepted,
  rejected,
  left,
  removed,
}
