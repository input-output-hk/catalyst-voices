import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/widget/proposal_builder_menu_item.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/publish_proposal_iteration_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/submit_proposal_for_review_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    show DocumentVersion, ProposalMenuItemAction;
import 'package:flutter/material.dart';

class ProposalBuilderStatusAction extends StatelessWidget {
  const ProposalBuilderStatusAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
        ({bool offstage, List<ProposalMenuItemAction> items})>(
      selector: (state) {
        return (
          offstage: state.isLoading || state.error != null,
          items: ProposalMenuItemAction.proposalBuilderAvailableOptions(
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
              padding: EdgeInsets.zero,
              child: ProposalBuilderMenuItem(item: item),
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

  bool _isLocal(ProposalPublish publish, int iteration) {
    return publish == ProposalPublish.localDraft &&
        iteration == DocumentVersion.firstNumber;
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

    if (!await bloc.isAccountEmailVerified()) {
      bloc.emitSignal(const EmailNotVerifiedProposalBuilderSignal());
      return;
    }

    if (!mounted || bloc.isClosed) {
      return;
    }

    if (!bloc.validate()) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final nextIteration =
        state.metadata.latestVersion?.number ?? DocumentVersion.firstNumber;

    // if it's local draft and the first version then
    // it should be shown as local which corresponds to null
    final currentIteration = _isLocal(state.metadata.publish, nextIteration)
        ? null
        : nextIteration - 1;

    final shouldPublish = await PublishProposalIterationDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentIteration: currentIteration,
          nextIteration: nextIteration,
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

    if (bloc.state.isMaxProposalsLimitReached) {
      bloc.add(const MaxProposalsLimitReachedEvent());
      return;
    }

    if (!bloc.validate()) {
      return;
    }

    if (!await bloc.isAccountEmailVerified()) {
      bloc.emitSignal(const EmailNotVerifiedProposalBuilderSignal());
      return;
    }

    if (!mounted || bloc.isClosed) {
      return;
    }

    final state = bloc.state;
    final proposalTitle = state.proposalTitle ??
        context.l10n.proposalEditorStatusDropdownViewTitle;
    final latestVersion = state.metadata.latestVersion!;

    final nextIteration = latestVersion.number;

    final int? currentIteration;
    if (_isLocal(state.metadata.publish, nextIteration)) {
      // if it's local draft and the first version then
      // it should be shown as local which corresponds to null
      currentIteration = null;
    } else if (state.metadata.publish == ProposalPublish.localDraft) {
      // current iteration is a local draft
      // so next iteration must increment the version
      currentIteration = nextIteration - 1;
    } else {
      // only changing status of the iteration, no need to increment the version
      currentIteration = nextIteration;
    }

    final shouldSubmit = await SubmitProposalForReviewDialog.show(
          context: context,
          proposalTitle: proposalTitle,
          currentIteration: currentIteration,
          nextIteration: nextIteration,
        ) ??
        false;

    if (shouldSubmit) {
      bloc.add(const SubmitProposalEvent());
    }
  }
}
