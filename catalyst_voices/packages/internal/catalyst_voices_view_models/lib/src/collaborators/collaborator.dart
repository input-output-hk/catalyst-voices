import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class Collaborator extends Equatable {
  final CatalystId catalystId;
  final CollaboratorInvitationStatus status;

  const Collaborator({
    required this.catalystId,
    required this.status,
  });

  @override
  List<Object?> get props => [catalystId, status];
}

/// A status of the collaborator invited to a document (proposal).
enum CollaboratorInvitationStatus {
  /// The invitation is pending, the collaborator needs to accept / reject.
  pending,

  /// The invitation is accepted by the collaborator.
  accepted,

  /// The invitation is rejected by the collaborator.
  rejected,

  /// The collaborator has accepted and then left.
  left,

  /// The collaborator has been removed.
  removed;

  Color labelColor(BuildContext context) {
    return switch (this) {
      CollaboratorInvitationStatus.pending ||
      CollaboratorInvitationStatus.accepted ||
      CollaboratorInvitationStatus.rejected ||
      CollaboratorInvitationStatus.removed => Theme.of(context).colors.textOnPrimaryLevel1,
      CollaboratorInvitationStatus.left => Theme.of(context).colors.textDisabled,
    };
  }

  String labelText(BuildContext context) {
    return switch (this) {
      CollaboratorInvitationStatus.pending => context.l10n.collaboratorInvitationStatusPending,
      CollaboratorInvitationStatus.accepted => context.l10n.collaboratorInvitationStatusAccepted,
      CollaboratorInvitationStatus.rejected => context.l10n.collaboratorInvitationStatusRejected,
      CollaboratorInvitationStatus.left => context.l10n.collaboratorInvitationStatusLeft,
      CollaboratorInvitationStatus.removed => context.l10n.collaboratorInvitationStatusRemoved,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      CollaboratorInvitationStatus.pending => Theme.of(context).colors.iconsDisabled,
      CollaboratorInvitationStatus.accepted => Theme.of(context).colors.iconsSuccess,
      CollaboratorInvitationStatus.rejected ||
      CollaboratorInvitationStatus.removed => Theme.of(context).colors.iconsError,
      CollaboratorInvitationStatus.left => Theme.of(context).colors.iconsDisabled,
    };
  }
}
