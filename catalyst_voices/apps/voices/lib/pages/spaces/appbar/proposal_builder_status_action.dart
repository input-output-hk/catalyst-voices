import 'dart:async';

import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/modals/proposals/publish_proposal_iteration_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/submit_proposal_for_review_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalBuilderStatusAction extends StatefulWidget {
  const ProposalBuilderStatusAction({super.key});

  @override
  State<ProposalBuilderStatusAction> createState() =>
      _ProposalBuilderStatusActionState();
}

class _Button extends StatelessWidget {
  final VoidCallback onTap;

  const _Button({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
      child: Row(
        children: [
          VoicesAssets.icons.documentText.buildIcon(size: 16),
          const SizedBox(width: 8),
          Text(
            context.l10n.proposalOptions,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          const VerticalDivider(width: 22),
          VoicesAssets.icons.chevronDown.buildIcon(size: 16),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final _MenuItemEnum item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
        ProposalBuilderBloc,
        ProposalBuilderState,
        ({
          String? proposalTitle,
          ProposalBuilderMetadata metadata,
        })>(
      selector: (state) => (
        proposalTitle: state.proposalTitle,
        metadata: state.metadata,
      ),
      builder: (context, state) {
        final title = item.title(context, state.proposalTitle);
        final description = item.description(context, state.metadata);

        return ListTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: description == null
              ? null
              : Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colors.textOnPrimaryLevel1,
                      ),
                ),
          leading: item.icon.buildIcon(),
          mouseCursor: item.clickable ? SystemMouseCursors.click : null,
        );
      },
    );
  }
}

enum _MenuItemEnum {
  view(clickable: false),
  publish(clickable: true),
  submit(clickable: true),
  share(clickable: true),
  export(clickable: true),
  delete(clickable: true);

  final bool clickable;

  const _MenuItemEnum({required this.clickable});

  SvgGenImage get icon {
    switch (this) {
      case _MenuItemEnum.view:
        return VoicesAssets.icons.badgeCheck;
      case _MenuItemEnum.publish:
        return VoicesAssets.icons.chatAlt2;
      case _MenuItemEnum.submit:
        return VoicesAssets.icons.badgeCheck;
      case _MenuItemEnum.share:
        return VoicesAssets.icons.upload;
      case _MenuItemEnum.export:
        return VoicesAssets.icons.folderOpen;
      case _MenuItemEnum.delete:
        return VoicesAssets.icons.trash;
    }
  }

  String? description(BuildContext context, ProposalBuilderMetadata metadata) {
    return switch (this) {
      _MenuItemEnum.view => _formatProposalDescription(context, metadata),
      _MenuItemEnum.publish =>
        context.l10n.proposalEditorStatusDropdownPublishDescription,
      _MenuItemEnum.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitDescription,
      _MenuItemEnum.share ||
      _MenuItemEnum.export ||
      _MenuItemEnum.delete =>
        null,
    };
  }

  String title(BuildContext context, String? proposalTitle) {
    return switch (this) {
      _MenuItemEnum.view => (proposalTitle != null && proposalTitle.isNotBlank)
          ? proposalTitle
          : context.l10n.proposalEditorStatusDropdownViewTitle,
      _MenuItemEnum.publish =>
        context.l10n.proposalEditorStatusDropdownPublishTitle,
      _MenuItemEnum.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitTitle,
      _MenuItemEnum.share =>
        context.l10n.proposalEditorStatusDropdownShareTitle,
      _MenuItemEnum.export =>
        context.l10n.proposalEditorStatusDropdownExportTitle,
      _MenuItemEnum.delete =>
        context.l10n.proposalEditorStatusDropdownDeleteTitle,
    };
  }

  String _formatProposalDescription(
    BuildContext context,
    ProposalBuilderMetadata metadata,
  ) {
    switch (metadata.publish) {
      case ProposalPublish.localDraft:
        return context.l10n.proposalEditorStatusDropdownViewDescriptionLocal;
      case ProposalPublish.publishedDraft:
        return context.l10n.proposalEditorStatusDropdownViewDescriptionDraft(
          metadata.version ?? Proposal.initialVersion,
        );
      case ProposalPublish.submittedProposal:
        return context.l10n.proposalEditorStatusDropdownViewDescriptionFinal(
          metadata.version ?? Proposal.initialVersion,
        );
    }
  }

  static List<_MenuItemEnum> availableOptions(ProposalPublish proposalPublish) {
    switch (proposalPublish) {
      case ProposalPublish.localDraft:
        return [view, publish, export, delete];
      case ProposalPublish.publishedDraft:
      case ProposalPublish.submittedProposal:
        return [view, publish, submit, share, export, delete];
    }
  }
}

class _ProposalBuilderStatusActionState
    extends State<ProposalBuilderStatusAction> {
  final GlobalKey<PopupMenuButtonState<int>> _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        ProposalBuilderMetadata>(
      selector: (state) => state.metadata,
      builder: (context, metadata) {
        final items = _MenuItemEnum.availableOptions(metadata.publish);
        return PopupMenuButton<int>(
          key: _buttonKey,
          offset: const Offset(0, 48),
          clipBehavior: Clip.antiAlias,
          constraints: const BoxConstraints(minWidth: 420),
          child: _Button(onTap: _showMenu),
          itemBuilder: (context) {
            return <PopupMenuEntry<int>>[
              for (final item in items)
                PopupMenuItem(
                  value: item.index,
                  enabled: item.clickable,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: _MenuItem(item: item),
                ),
            ].separatedBy(const PopupMenuDivider(height: 0)).toList();
          },
          onSelected: (value) {
            final item = _MenuItemEnum.values[value];
            _onSelected(context, item);
          },
        );
      },
    );
  }

  void _onSelected(BuildContext context, _MenuItemEnum item) {
    switch (item) {
      case _MenuItemEnum.view:
        // do nothing
        break;
      case _MenuItemEnum.publish:
        unawaited(_publishIteration(context));
      case _MenuItemEnum.submit:
        unawaited(_submitForReview(context));
      case _MenuItemEnum.share:
        unawaited(_shareProposal(context));
      case _MenuItemEnum.export:
        context.read<ProposalBuilderBloc>().add(const ExportProposalEvent());
      case _MenuItemEnum.delete:
        context.read<ProposalBuilderBloc>().add(const DeleteProposalEvent());
    }
  }

  Future<void> _publishIteration(BuildContext context) async {
    final bloc = context.read<ProposalBuilderBloc>();
    if (!bloc.validate()) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final version = state.metadata.version;

    final shouldPublish = await PublishProposalIterationDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentVersion: version,
          nextVersion: (version ?? Proposal.initialVersion) + 1,
        ) ??
        false;

    if (shouldPublish) {
      bloc.add(const PublishProposalEvent());
    }
  }

  Future<void> _shareProposal(BuildContext context) async {
    final state = context.read<ProposalBuilderBloc>().state;
    final proposalId = state.metadata.documentRef?.id;
    if (proposalId != null) {
      // TODO(LynxLynxx): Change to proposal view route when implemented
      final url = ProposalBuilderRoute(proposalId: proposalId).location;
      await ShareProposalDialog.show(context, url);
    }
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }

  Future<void> _submitForReview(BuildContext context) async {
    final bloc = context.read<ProposalBuilderBloc>();
    if (!bloc.validate()) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final version = state.metadata.version ?? Proposal.initialVersion;

    final shouldSubmit = await SubmitProposalForReviewDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentVersion: version,
          nextVersion: version + 1,
        ) ??
        false;

    if (shouldSubmit) {
      bloc.add(const SubmitProposalEvent());
    }
  }
}
