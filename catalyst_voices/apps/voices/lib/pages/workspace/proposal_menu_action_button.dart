import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/modals/proposals/forget_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/unlock_edit_proposal.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/proposal_builder/proposal_menu_item_action_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalMenuActionButton extends StatefulWidget {
  final DocumentRef ref;
  final ProposalPublish proposalPublish;
  final int version;
  final String title;

  const ProposalMenuActionButton({
    super.key,
    required this.ref,
    required this.proposalPublish,
    required this.version,
    required this.title,
  });

  @override
  State<ProposalMenuActionButton> createState() =>
      _ProposalMenuActionButtonState();
}

class _MenuItem extends StatelessWidget {
  final ProposalMenuItemAction item;
  final ProposalPublish proposalPublish;

  const _MenuItem({
    required this.item,
    required this.proposalPublish,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.icon(workspace: true).buildIcon(),
      title: Text(
        item.workspaceTitle(context, proposalPublish),
      ),
      mouseCursor: item.clickable ? SystemMouseCursors.click : null,
    );
  }
}

class _ProposalMenuActionButtonState extends State<ProposalMenuActionButton> {
  final GlobalKey<PopupMenuButtonState<int>> _buttonKey = GlobalKey();

  bool get _isSubmitted => widget.proposalPublish.isPublished;

  List<ProposalMenuItemAction> get _items =>
      ProposalMenuItemAction.workspaceAvailableOptions(
        widget.proposalPublish,
      );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: _buttonKey,
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints(minWidth: 420),
      offset: const Offset(-40, 0),
      itemBuilder: (context) {
        return <PopupMenuEntry<int>>[
          for (final item in _items)
            PopupMenuItem(
              value: item.index,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: _MenuItem(
                item: item,
                proposalPublish: widget.proposalPublish,
              ),
            ),
        ];
      },
      child: VoicesIconButton(
        onTap: _showMenu,
        style: IconButton.styleFrom(
          foregroundColor:
              _isSubmitted ? context.colors.textOnPrimaryWhite : null,
        ),
        child: VoicesAssets.icons.dotsVertical.buildIcon(),
      ),
      onSelected: (value) {
        final item = ProposalMenuItemAction.values[value];
        _onSelected(item);
      },
    );
  }

  Future<void> _deleteProposal() async {
    final ref = widget.ref;
    if (ref is DraftRef) {
      final confirmed = await ProposalBuilderDeleteConfirmationDialog.show(
        context,
        routeSettings: const RouteSettings(
          name: '/proposal_builder/delete-confirmation',
        ),
      );

      if (confirmed && mounted) {
        context
            .read<WorkspaceBloc>()
            .add(DeleteDraftProposalEvent(ref: widget.ref as DraftRef));
      }
    }
  }

  Future<void> _editProposal() async {
    if (widget.proposalPublish.isPublished) {
      final edit = await UnlockEditProposalDialog.show(
            context: context,
            title: widget.title,
            version: widget.version,
          ) ??
          false;
      if (edit && mounted) {
        context.read<WorkspaceBloc>().add(UnlockProposalEvent(widget.ref));
      }
    } else if (mounted) {
      unawaited(
        ProposalBuilderRoute.fromRef(ref: widget.ref).push(context),
      );
    }
  }

  void _exportProposal() {
    final prefix = context.l10n.proposal.toLowerCase();
    context.read<WorkspaceBloc>().add(ExportProposal(widget.ref, prefix));
  }

  Future<void> _forgetProposal() async {
    final action = await ForgetProposalDialog.show(
      context: context,
      title: widget.title,
      version: widget.version,
      publish: widget.proposalPublish,
    );
    if (action == null) return;
    switch (action) {
      case ExportProposalForgetAction():
        _exportProposal();
      case ForgetProposalForgetAction():
        if (mounted) {
          context.read<WorkspaceBloc>().add(ForgetProposalEvent(widget.ref));
        }
    }
  }

  void _onSelected(ProposalMenuItemAction item) {
    switch (item) {
      case ProposalMenuItemAction.edit:
        unawaited(_editProposal());
      case ProposalMenuItemAction.view:
        _viewProposal();
      case ProposalMenuItemAction.share:
        _shareProposal();
      case ProposalMenuItemAction.export:
        _exportProposal();
      case ProposalMenuItemAction.delete:
        unawaited(_deleteProposal());
      case ProposalMenuItemAction.forget:
        unawaited(_forgetProposal());
      case _:
        break;
    }
  }

  void _shareProposal() {
    final url = ProposalRoute.fromRef(ref: widget.ref).location;
    unawaited(ShareProposalDialog.show(context, url));
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }

  void _viewProposal() {
    unawaited(ProposalRoute.fromRef(ref: widget.ref).push(context));
  }
}
