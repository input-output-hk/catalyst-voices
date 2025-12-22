import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// Enum representing proposal menu item actions
enum ProposalMenuItemAction {
  view(clickable: false),
  edit,
  publish,
  submit,
  forget,
  export,
  share,
  delete,
  leave;

  final bool clickable;

  const ProposalMenuItemAction({this.clickable = true});

  String? description(
    BuildContext context, {
    required int currentIteration,
  }) {
    return switch (this) {
      ProposalMenuItemAction.view => _formatProposalDescription(
        context,
        currentIteration: currentIteration,
      ),
      ProposalMenuItemAction.publish => context.l10n.proposalEditorStatusDropdownPublishDescription,
      ProposalMenuItemAction.submit => context.l10n.proposalEditorStatusDropdownSubmitDescription,
      _ => null,
    };
  }

  SvgGenImage icon({bool workspace = false}) {
    switch (this) {
      case ProposalMenuItemAction.view:
        return workspace ? VoicesAssets.icons.eye : VoicesAssets.icons.documentText;
      case ProposalMenuItemAction.publish:
        return VoicesAssets.icons.chatAlt2;
      case ProposalMenuItemAction.submit:
        return VoicesAssets.icons.badgeCheck;
      case ProposalMenuItemAction.export:
        return workspace ? VoicesAssets.icons.duplicate : VoicesAssets.icons.folderOpen;
      case ProposalMenuItemAction.delete:
        return VoicesAssets.icons.trash;
      case ProposalMenuItemAction.edit:
        return VoicesAssets.icons.pencilAlt;
      case ProposalMenuItemAction.forget:
        return VoicesAssets.icons.unlink;
      case ProposalMenuItemAction.share:
        return VoicesAssets.icons.upload;
      case ProposalMenuItemAction.leave:
        return VoicesAssets.icons.unlink;
    }
  }

  String title(
    BuildContext context,
    String? proposalTitle,
    int currentIteration,
  ) {
    return switch (this) {
      ProposalMenuItemAction.view =>
        (proposalTitle != null && proposalTitle.isNotBlank)
            ? proposalTitle
            : context.l10n.proposalEditorStatusDropdownViewTitle,
      ProposalMenuItemAction.publish => context.l10n.proposalEditorStatusDropdownPublishTitle(
        currentIteration,
      ),
      ProposalMenuItemAction.submit => context.l10n.proposalEditorStatusDropdownSubmitTitle(
        currentIteration,
      ),
      ProposalMenuItemAction.forget => context.l10n.forgetProposal,
      ProposalMenuItemAction.export => context.l10n.proposalEditorStatusDropdownExportTitle,
      ProposalMenuItemAction.delete => context.l10n.proposalEditorStatusDropdownDeleteTitle,
      _ => '',
    };
  }

  String workspaceTitle(BuildContext context, ProposalPublish proposalPublish) {
    final isFinal = proposalPublish.isPublished;
    return switch (this) {
      ProposalMenuItemAction.edit =>
        isFinal ? context.l10n.unlockAndEdit : context.l10n.editButtonText,
      ProposalMenuItemAction.view => context.l10n.view,
      ProposalMenuItemAction.share => context.l10n.share,
      ProposalMenuItemAction.forget => context.l10n.forgetProposal,
      ProposalMenuItemAction.export => context.l10n.export,
      ProposalMenuItemAction.delete => context.l10n.delete,
      ProposalMenuItemAction.leave => context.l10n.leaveProposal,
      _ => '',
    };
  }

  String _formatProposalDescription(
    BuildContext context, {
    required int currentIteration,
  }) {
    return context.l10n.proposalEditorStatusDropdownViewDescription(
      currentIteration,
    );
  }

  /// Returns the available options for a proposal in a proposal builder
  static List<ProposalMenuItemAction> proposalBuilderAvailableOptions(
    ProposalPublish proposalPublish, {
    required bool fromActiveCampaign,
  }) {
    if (!fromActiveCampaign) {
      return [view];
    }

    switch (proposalPublish) {
      case ProposalPublish.localDraft:
        return [view, publish, submit, export, delete];
      case ProposalPublish.publishedDraft:
        return [view, submit, forget, export];
      case ProposalPublish.submittedProposal:
        // Submitted can't be open in editor
        return [];
    }
  }

  /// Returns the available options for a proposal in a workspace
  static List<ProposalMenuItemAction> workspaceAvailableOptions(
    ProposalPublish proposalPublish, {
    required bool fromActiveCampaign,
    required UserProposalOwnership ownership,
  }) {
    return switch (proposalPublish) {
      _ when !fromActiveCampaign => [view],
      ProposalPublish.localDraft when ownership is AuthorProposalOwnership => [
        edit,
        view,
        export,
        delete,
      ],
      _ when ownership is CollaboratorProposalOwnership => [
        view,
        share,
        export,
        leave,
      ],
      _ => [
        edit,
        view,
        share,
        forget,
        export,
      ],
    };
  }
}
