import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

enum ProposalMenuItemAction {
  view(clickable: false),
  back,
  edit,
  publish,
  submit,
  forget,
  export,
  share,
  delete;

  final bool clickable;

  const ProposalMenuItemAction({this.clickable = true});

  String? description(BuildContext context, ProposalBuilderMetadata metadata) {
    return switch (this) {
      ProposalMenuItemAction.view =>
        _formatProposalDescription(context, metadata),
      ProposalMenuItemAction.publish =>
        context.l10n.proposalEditorStatusDropdownPublishDescription,
      ProposalMenuItemAction.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitDescription,
      _ => null,
    };
  }

  SvgGenImage icon({bool workspace = false}) {
    switch (this) {
      case ProposalMenuItemAction.view:
        return workspace
            ? VoicesAssets.icons.eye
            : VoicesAssets.icons.documentText;
      case ProposalMenuItemAction.back:
        return VoicesAssets.icons.logout1;
      case ProposalMenuItemAction.publish:
        return VoicesAssets.icons.chatAlt2;
      case ProposalMenuItemAction.submit:
        return VoicesAssets.icons.badgeCheck;
      case ProposalMenuItemAction.export:
        return workspace
            ? VoicesAssets.icons.duplicate
            : VoicesAssets.icons.folderOpen;
      case ProposalMenuItemAction.delete:
        return VoicesAssets.icons.trash;
      case ProposalMenuItemAction.edit:
        return VoicesAssets.icons.pencilAlt;
      case ProposalMenuItemAction.forget:
        return VoicesAssets.icons.unlink;
      case ProposalMenuItemAction.share:
        return VoicesAssets.icons.upload;
    }
  }

  String title(
    BuildContext context,
    String? proposalTitle,
    int currentIteration,
  ) {
    final nextIteration = currentIteration + 1;
    return switch (this) {
      ProposalMenuItemAction.view =>
        (proposalTitle != null && proposalTitle.isNotBlank)
            ? proposalTitle
            : context.l10n.proposalEditorStatusDropdownViewTitle,
      ProposalMenuItemAction.back => context.l10n.proposalEditorBackToProposals,
      ProposalMenuItemAction.publish =>
        context.l10n.proposalEditorStatusDropdownPublishTitle(nextIteration),
      ProposalMenuItemAction.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitTitle(nextIteration),
      ProposalMenuItemAction.forget => context.l10n.forgetProposal,
      ProposalMenuItemAction.export =>
        context.l10n.proposalEditorStatusDropdownExportTitle,
      ProposalMenuItemAction.delete =>
        context.l10n.proposalEditorStatusDropdownDeleteTitle,
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
      _ => '',
    };
  }

  String _formatProposalDescription(
    BuildContext context,
    ProposalBuilderMetadata metadata,
  ) {
    final currentIteration = metadata.latestVersion?.number ?? 0;
    final nextIteration = currentIteration + 1;
    return context.l10n.proposalEditorStatusDropdownViewDescription(
      nextIteration,
    );
  }

  static List<ProposalMenuItemAction> availableOptions(
    ProposalPublish proposalPublish, {
    bool workspace = false,
  }) {
    if (workspace) {
      return switch (proposalPublish) {
        ProposalPublish.localDraft => [edit, export, delete],
        _ => [
            edit,
            view,
            share,
            forget,
            export,
          ],
      };
    }

    switch (proposalPublish) {
      case ProposalPublish.localDraft:
        return [view, back, publish, submit, export, delete];
      case ProposalPublish.publishedDraft:
        return [view, back, submit, forget, export];
      case ProposalPublish.submittedProposal:
        // Submitted can't be open in editor
        return [];
    }
  }
}
