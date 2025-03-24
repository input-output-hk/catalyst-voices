import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_menu_item_action_enum.dart';
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
        ({bool offstage, List<ProposalMenuItemAction> items})>(
      selector: (state) {
        return (
          offstage: state.isChanging || state.error != null,
          items: ProposalMenuItemAction.availableOptions(
            state.metadata.publish,
          )
        );
      },
      builder: (context, state) {
        return Offstage(
          offstage: state.offstage,
          child: _PopupMenuButton(items: state.items),
        );
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
  final ProposalMenuItemAction item;
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
      title: MarkdownText(
        selectable: false,
        MarkdownData(title),
      ),
      subtitle: description == null
          ? null
          : Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colors.textOnPrimaryLevel1,
                  ),
            ),
      leading: item.icon().buildIcon(),
      mouseCursor: item.clickable ? SystemMouseCursors.click : null,
    );
  }
}

class _MenuItemSelector extends StatelessWidget {
  final ProposalMenuItemAction item;

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
  final List<ProposalMenuItemAction> items;

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
        final item = ProposalMenuItemAction.values[value];

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

  void _onSelected(ProposalMenuItemAction item) {
    switch (item) {
      case ProposalMenuItemAction.publish:
        unawaited(_publishIteration());
      case ProposalMenuItemAction.submit:
        unawaited(_submitForReview());
      case ProposalMenuItemAction.export:
        _exportProposal();
      case ProposalMenuItemAction.delete:
        unawaited(_deleteProposal());
      case _:
        break;
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
