import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A collaborator on the proposal. Not the author.
final class Collaborator extends Equatable {
  final CatalystId id;
  final ProposalsCollaborationStatus status;
  final DateTime? createdAt;

  const Collaborator({
    required this.id,
    required this.status,
    this.createdAt,
  });

  factory Collaborator.fromBriefData(ProposalDataCollaborator briefData) {
    return Collaborator(
      id: briefData.id,
      status: briefData.status,
      createdAt: briefData.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, status, createdAt];
}

/// A status of the collaborator invited to a document (proposal).
extension ProposalsCollaborationStatusExt on ProposalsCollaborationStatus {
  SvgGenImage icon(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending => VoicesAssets.icons.clock,
      ProposalsCollaborationStatus.accepted ||
      ProposalsCollaborationStatus.mainProposer => VoicesAssets.icons.check,
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.removed => VoicesAssets.icons.x,
      ProposalsCollaborationStatus.left => VoicesAssets.icons.unlink,
    };
  }

  Color labelColor(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending ||
      ProposalsCollaborationStatus.accepted ||
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.mainProposer ||
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
      ProposalsCollaborationStatus.mainProposer => context.l10n.mainProposer,
    };
  }

  String? proposalApprovalFinalSecondaryLabel(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.accepted || ProposalsCollaborationStatus.mainProposer => null,
      ProposalsCollaborationStatus.pending ||
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.left ||
      ProposalsCollaborationStatus.removed => context.l10n.notShownOnFinalProposal,
    };
  }

  String proposalApprovalLabel(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending => context.l10n.collaboratorAwaitingApproval,
      ProposalsCollaborationStatus.accepted => context.l10n.collaboratorApprovedFinal,
      ProposalsCollaborationStatus.rejected => context.l10n.collaboratorInvitationStatusRejected,
      ProposalsCollaborationStatus.left => context.l10n.collaboratorInvitationStatusLeft,
      ProposalsCollaborationStatus.removed => context.l10n.collaboratorInvitationStatusRemoved,
      ProposalsCollaborationStatus.mainProposer => context.l10n.collaboratorApprovedFinal,
    };
  }

  Color statusColor(BuildContext context) {
    return switch (this) {
      ProposalsCollaborationStatus.pending => Theme.of(context).colors.iconsDisabled,
      ProposalsCollaborationStatus.accepted ||
      ProposalsCollaborationStatus.mainProposer => Theme.of(context).colors.iconsSuccess,
      ProposalsCollaborationStatus.rejected ||
      ProposalsCollaborationStatus.removed => Theme.of(context).colors.iconsError,
      ProposalsCollaborationStatus.left => Theme.of(context).colors.iconsDisabled,
    };
  }
}
