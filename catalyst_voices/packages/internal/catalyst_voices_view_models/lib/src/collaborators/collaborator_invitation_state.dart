import 'package:equatable/equatable.dart';

final class AcceptedCollaboratorInvitationState extends CollaboratorInvitationState {
  const AcceptedCollaboratorInvitationState();
}

sealed class CollaboratorInvitationState extends Equatable {
  const CollaboratorInvitationState();

  @override
  List<Object?> get props => [];
}

final class NoneCollaboratorInvitationState extends CollaboratorInvitationState {
  const NoneCollaboratorInvitationState();
}

final class PendingCollaboratorInvitationState extends CollaboratorInvitationState {
  const PendingCollaboratorInvitationState();
}

final class RejectedCollaboratorInvitationState extends CollaboratorInvitationState {
  const RejectedCollaboratorInvitationState();
}
