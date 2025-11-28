import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  factory CollaboratorInvite.fromBriefData(ProposalBriefDataCollaborator briefData) {
    return CollaboratorInvite(
      catalystId: briefData.id,
      status: CollaboratorInviteStatus.fromStatusFilter(briefData.status),
    );
  }

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
    if (activeAccountId != null && authorId != null && activeAccountId.isSameAs(authorId)) {
      return AllCollaboratorInvites(collaborators);
    }

    if (activeAccountId != null &&
        collaborators.any((e) => e.catalystId.isSameAs(activeAccountId))) {
      return AllCollaboratorInvites(collaborators);
    }

    return AcceptedCollaboratorInvites(
      collaborators.where((e) => e.status == CollaboratorInviteStatus.accepted).toList(),
    );
  }

  @override
  List<Object?> get props => [invites];
}

/// A status of the collaborator invited to a document (proposal).
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
  removed;

  const CollaboratorInviteStatus();

  factory CollaboratorInviteStatus.fromStatusFilter(
    ProposalsCollaborationStatus statusFilter,
  ) {
    return switch (statusFilter) {
      ProposalsCollaborationStatus.accepted => accepted,
      ProposalsCollaborationStatus.pending => pending,
      ProposalsCollaborationStatus.rejected => rejected,
      // TODO(LynxLynxx): Add missing values left and removed.
    };
  }

  Color labelColor(BuildContext context) {
    return switch (this) {
      CollaboratorInviteStatus.pending ||
      CollaboratorInviteStatus.accepted ||
      CollaboratorInviteStatus.rejected ||
      CollaboratorInviteStatus.removed => Theme.of(context).colors.textOnPrimaryLevel1,
      CollaboratorInviteStatus.left => Theme.of(context).colors.textDisabled,
    };
  }

  String labelText(BuildContext context) {
    return switch (this) {
      CollaboratorInviteStatus.pending => context.l10n.collaboratorInvitationStatusPending,
      CollaboratorInviteStatus.accepted => context.l10n.collaboratorInvitationStatusAccepted,
      CollaboratorInviteStatus.rejected => context.l10n.collaboratorInvitationStatusRejected,
      CollaboratorInviteStatus.left => context.l10n.collaboratorInvitationStatusLeft,
      CollaboratorInviteStatus.removed => context.l10n.collaboratorInvitationStatusRemoved,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      CollaboratorInviteStatus.pending => Theme.of(context).colors.iconsDisabled,
      CollaboratorInviteStatus.accepted => Theme.of(context).colors.iconsSuccess,
      CollaboratorInviteStatus.rejected ||
      CollaboratorInviteStatus.removed => Theme.of(context).colors.iconsError,
      CollaboratorInviteStatus.left => Theme.of(context).colors.iconsDisabled,
    };
  }
}
