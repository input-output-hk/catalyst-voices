import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CollaboratorInvitationState extends Equatable {
  final CollaboratorInvitation? invitation;
  final bool showAsAccepted;
  final bool showAsRejected;

  const CollaboratorInvitationState({
    this.invitation,
    this.showAsAccepted = false,
    this.showAsRejected = false,
  });

  @override
  List<Object?> get props => [invitation, showAsAccepted, showAsRejected];
}
