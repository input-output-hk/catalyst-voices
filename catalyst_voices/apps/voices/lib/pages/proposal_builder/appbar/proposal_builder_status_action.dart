import 'dart:async';

import 'package:catalyst_voices/pages/proposal_builder/dialog/proposal_builder_delete_confirmation_dialog.dart';
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
        final title = item.title(
          context,
          state.proposalTitle,
          state.metadata.currentIteration,
        );

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
  export(clickable: true),
  delete(clickable: true);

  final bool clickable;

  const _MenuItemEnum({required this.clickable});

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
    final nextIteration = metadata.currentIteration + 1;
    return context.l10n.proposalEditorStatusDropdownViewDescription(
      nextIteration,
    );
  }

  static List<_MenuItemEnum> availableOptions(ProposalPublish proposalPublish) {
    switch (proposalPublish) {
      case ProposalPublish.localDraft:
        return _MenuItemEnum.values;
      case ProposalPublish.publishedDraft:
      case ProposalPublish.submittedProposal:
        return [view, publish, submit, export];
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
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

  Future<void> _deleteProposal(BuildContext context) async {
    final confirmed = await VoicesQuestionDialog.show(
      context,
      routeSettings: const RouteSettings(
        name: '/proposal_builder/delete-confirmation',
      ),
      builder: (_) => const ProposalBuilderDeleteConfirmationDialog(),
    );

    if (confirmed && context.mounted) {
      context.read<ProposalBuilderBloc>().add(const DeleteProposalEvent());
    }
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
      case _MenuItemEnum.export:
        context.read<ProposalBuilderBloc>().add(const ExportProposalEvent());
      case _MenuItemEnum.delete:
        unawaited(_deleteProposal(context));
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
    final iteration = state.metadata.currentIteration;

    final shouldPublish = await PublishProposalIterationDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentIteration: iteration == 0 ? null : iteration,
          nextIteration: iteration + 1,
        ) ??
        false;

    if (shouldPublish) {
      bloc.add(const PublishProposalEvent());
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
    final iteration = state.metadata.currentIteration;

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
