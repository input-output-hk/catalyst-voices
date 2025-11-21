import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

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

final class CollaboratorInvites extends Equatable {
  final List<CollaboratorInvite> invites;

  const CollaboratorInvites([this.invites = const []]);

  @override
  List<Object?> get props => invites;
}

/// A state of the collaborator invited to a document (proposal).
enum CollaboratorInviteStatus {
  pending,
  accepted,
  rejected,
  left,
  removed,
}
