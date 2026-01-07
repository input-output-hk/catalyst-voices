import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CollaboratorDisplayConsentStatus {
  pending,
  allowed,
  denied;

  const CollaboratorDisplayConsentStatus();

  factory CollaboratorDisplayConsentStatus.fromCollaborationStatus(
    ProposalsCollaborationStatus? status,
  ) {
    return switch (status) {
      ProposalsCollaborationStatus.accepted => CollaboratorDisplayConsentStatus.allowed,
      ProposalsCollaborationStatus.rejected => CollaboratorDisplayConsentStatus.denied,
      // For other statuses, default to pending
      _ => CollaboratorDisplayConsentStatus.pending,
    };
  }

  SvgGenImage get icons {
    return switch (this) {
      pending => VoicesAssets.icons.clock,
      allowed => VoicesAssets.icons.check,
      denied => VoicesAssets.icons.x,
    };
  }

  String changedStatusToLocalized(BuildContext context) {
    return switch (this) {
      allowed => context.l10n.allow,
      denied => context.l10n.deny,
      _ => '',
    };
  }

  String currentStatusLocalized(BuildContext context) {
    return switch (this) {
      pending => context.l10n.collaboratorInvitationStatusPending,
      allowed => context.l10n.allowed,
      denied => context.l10n.denied,
    };
  }
}

class CollaboratorProposalDisplayConsent extends Equatable {
  final DocumentRef id;
  final String title;
  final String categoryName;
  final CatalystId? originalAuthor;
  final CollaboratorDisplayConsentStatus status;

  const CollaboratorProposalDisplayConsent({
    required this.id,
    required this.title,
    required this.categoryName,
    required this.originalAuthor,
    required this.status,
  });

  factory CollaboratorProposalDisplayConsent.empty(CollaboratorDisplayConsentStatus status) {
    return CollaboratorProposalDisplayConsent(
      id: SignedDocumentRef.generateFirstRef(),
      title: 'A Proposal for which you still have to decide if you want to be displayed yes or no.',
      categoryName: 'F16: Cardano Use Cases: Concept',
      originalAuthor: DummyCatalystIdFactory.create(),
      status: status,
    );
  }

  factory CollaboratorProposalDisplayConsent.fromBrief(
    ProposalBriefData proposal,
    CatalystId activeAccountId,
  ) {
    final collaboratorStatus = proposal.collaborators
        ?.firstWhere((collaborator) => collaborator.id.isSameAs(activeAccountId))
        .status;
    final displayConsentStatus = CollaboratorDisplayConsentStatus.fromCollaborationStatus(
      collaboratorStatus,
    );

    return CollaboratorProposalDisplayConsent(
      id: proposal.id,
      title: proposal.title ?? '',
      categoryName: proposal.categoryName ?? '',
      originalAuthor: proposal.author,
      status: displayConsentStatus,
    );
  }

  @override
  List<Object?> get props => [id, title, categoryName, originalAuthor, status];
}

extension CollaboratorDisplayConsentStatusAllowedOptions on CollaboratorDisplayConsentStatus {
  static List<CollaboratorDisplayConsentStatus> get allowedOptions {
    return [
      CollaboratorDisplayConsentStatus.allowed,
      CollaboratorDisplayConsentStatus.denied,
    ];
  }
}
