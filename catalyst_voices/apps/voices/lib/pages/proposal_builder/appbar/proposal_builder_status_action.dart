import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/publish_proposal_iteration_dialog.dart';
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

class ProposalBuilderStatusAction extends StatelessWidget {
  const ProposalBuilderStatusAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        List<_MenuItemEnum>>(
      selector: (state) {
        return _MenuItemEnum.availableOptions(state.metadata.publish);
      },
      builder: (context, items) {
        return _PopupMenuButton(items: items);
      },
    );
  }
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
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colorScheme.onPrimary,
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
  final String? proposalTitle;
  final ProposalBuilderMetadata metadata;

  const _MenuItem({
    required this.item,
    required this.proposalTitle,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    final title = item.title(
      context,
      proposalTitle,
      metadata.latestVersion?.number ?? 0,
    );

    final description = item.description(context, metadata);

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
  }
}

enum _MenuItemEnum {
  view(clickable: false),
  publish,
  submit,
  export,
  delete;

  final bool clickable;

  const _MenuItemEnum({this.clickable = true});

  SvgGenImage get icon {
    switch (this) {
      case _MenuItemEnum.view:
        return VoicesAssets.icons.documentText;
      case _MenuItemEnum.publish:
        return VoicesAssets.icons.chatAlt2;
      case _MenuItemEnum.submit:
        return VoicesAssets.icons.badgeCheck;
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
      _MenuItemEnum.export || _MenuItemEnum.delete => null,
    };
  }

  String title(
    BuildContext context,
    String? proposalTitle,
    int currentIteration,
  ) {
    final nextIteration = currentIteration + 1;
    return switch (this) {
      _MenuItemEnum.view => (proposalTitle != null && proposalTitle.isNotBlank)
          ? proposalTitle
          : context.l10n.proposalEditorStatusDropdownViewTitle,
      _MenuItemEnum.publish =>
        context.l10n.proposalEditorStatusDropdownPublishTitle(nextIteration),
      _MenuItemEnum.submit =>
        context.l10n.proposalEditorStatusDropdownSubmitTitle(nextIteration),
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
    final currentIteration = metadata.latestVersion?.number ?? 0;
    final nextIteration = currentIteration + 1;
    return context.l10n.proposalEditorStatusDropdownViewDescription(
      nextIteration,
    );
  }

  static List<_MenuItemEnum> availableOptions(ProposalPublish proposalPublish) {
    switch (proposalPublish) {
      case ProposalPublish.localDraft:
        return _MenuItemEnum.values;
      case ProposalPublish.publishedDraft:
        // TODO(dtscalac): delete? revert?
        return [view, submit, export];
      case ProposalPublish.submittedProposal:
        // TODO(dtscalac): delete? revert?
        return [view, export];
    }
  }
}

class _MenuItemSelector extends StatelessWidget {
  final _MenuItemEnum item;

  const _MenuItemSelector({required this.item});

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
        return _MenuItem(
          item: item,
          proposalTitle: state.proposalTitle,
          metadata: state.metadata,
        );
      },
    );
  }
}

class _PopupMenuButton extends StatefulWidget {
  final List<_MenuItemEnum> items;

  const _PopupMenuButton({required this.items});

  @override
  State<_PopupMenuButton> createState() => _PopupMenuButtonState();
}

class _PopupMenuButtonState extends State<_PopupMenuButton> {
  final GlobalKey<PopupMenuButtonState<int>> _buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: _buttonKey,
      offset: const Offset(0, 48),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 420),
      child: _Button(onTap: _showMenu),
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          for (final item in widget.items)
            PopupMenuItem(
              value: item.index,
              enabled: item.clickable,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: _MenuItemSelector(item: item),
            ),
        ].separatedBy(const PopupMenuDivider(height: 0)).toList();
      },
      onSelected: (value) {
        final item = _MenuItemEnum.values[value];
        _onSelected(item);
      },
    );
  }

  Future<void> _deleteProposal() async {
    final confirmed = await ProposalBuilderDeleteConfirmationDialog.show(
      context,
      routeSettings: const RouteSettings(
        name: '/proposal_builder/delete-confirmation',
      ),
    );

    if (confirmed && mounted) {
      context.read<ProposalBuilderBloc>().add(const DeleteProposalEvent());
    }
  }

  void _exportProposal() {
    final prefix = context.l10n.proposal.toLowerCase();
    context
        .read<ProposalBuilderBloc>()
        .add(ExportProposalEvent(filePrefix: prefix));
  }

  void _onSelected(_MenuItemEnum item) {
    switch (item) {
      case _MenuItemEnum.view:
        // do nothing
        break;
      case _MenuItemEnum.publish:
        unawaited(_publishIteration());
      case _MenuItemEnum.submit:
        unawaited(_submitForReview());
      case _MenuItemEnum.export:
        _exportProposal();
      case _MenuItemEnum.delete:
        unawaited(_deleteProposal());
    }
  }

  Future<void> _publishIteration() async {
    final bloc = context.read<ProposalBuilderBloc>();
    if (!bloc.validate()) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final iteration = state.metadata.latestVersion?.number;

    final shouldPublish = await PublishProposalIterationDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentIteration: iteration,
          nextIteration: (iteration ?? 0) + 1,
        ) ??
        false;

    if (shouldPublish) {
      bloc.add(const PublishProposalEvent());
    }
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }

  Future<void> _submitForReview() async {
    final bloc = context.read<ProposalBuilderBloc>();
    if (!bloc.validate()) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final iteration = state.metadata.latestVersion!.number;

    final shouldSubmit = await SubmitProposalForReviewDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentIteration: iteration,
          nextIteration: iteration + 1,
        ) ??
        false;

    if (shouldSubmit) {
      bloc.add(const SubmitProposalEvent());
    }
  }
}
