import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class UserProposalInvites extends Equatable {
  // TODO(LynxLynxx): refactor this when we know how invites will look like;
  final ProposalsCollaborationStatusFilter status;
  final List<Object> invites;

  const UserProposalInvites({required this.status, this.invites = const []});

  @override
  List<Object?> get props => [status, invites];

  UserProposalInvites copyWith({
    ProposalsCollaborationStatusFilter? status,
    List<Object>? invites,
  }) {
    return UserProposalInvites(
      status: status ?? this.status,
      invites: invites ?? this.invites,
    );
  }
}
