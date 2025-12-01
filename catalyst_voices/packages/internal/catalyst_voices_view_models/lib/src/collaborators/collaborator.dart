import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class Collaborator extends Equatable {
  final CatalystId catalystId;
  final ProposalsCollaborationStatus status;

  const Collaborator({
    required this.catalystId,
    required this.status,
  });

  factory Collaborator.fromBriefData(ProposalBriefDataCollaborator briefData) {
    return Collaborator(
      catalystId: briefData.id,
      status: briefData.status,
    );
  }

  @override
  List<Object?> get props => [catalystId, status];
}

/// A status of the collaborator invited to a document (proposal).
extension ProposalsCollaborationStatusExt on ProposalsCollaborationStatus {
  Color labelColor(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending ||
      ProposalsCollaborationStatus.accepted ||
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.removed => Theme.of(context).colors.textOnPrimaryLevel1,
      ProposalsCollaborationStatus.left => Theme.of(context).colors.textDisabled,
    };
  }

  String labelText(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending => context.l10n.collaboratorInvitationStatusPending,
      ProposalsCollaborationStatus.accepted => context.l10n.collaboratorInvitationStatusAccepted,
      ProposalsCollaborationStatus.rejected => context.l10n.collaboratorInvitationStatusRejected,
      ProposalsCollaborationStatus.left => context.l10n.collaboratorInvitationStatusLeft,
      ProposalsCollaborationStatus.removed => context.l10n.collaboratorInvitationStatusRemoved,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending => Theme.of(context).colors.iconsDisabled,
      ProposalsCollaborationStatus.accepted => Theme.of(context).colors.iconsSuccess,
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.removed => Theme.of(context).colors.iconsError,
      ProposalsCollaborationStatus.left => Theme.of(context).colors.iconsDisabled,
    };
  }
}
