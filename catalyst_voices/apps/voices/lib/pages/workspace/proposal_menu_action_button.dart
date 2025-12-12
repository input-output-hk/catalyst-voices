import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/modals/proposals/forget_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/leave_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/share_proposal_dialog.dart';
import 'package:catalyst_voices/widgets/modals/proposals/unlock_edit_proposal.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart' hide PopupMenuItem;
import 'package:flutter/material.dart';

class ProposalMenuActionButton extends StatefulWidget {
  final DocumentRef ref;
  final ProposalPublish proposalPublish;
  final int version;
  final String title;
  final bool hasNewerLocalIteration;
  final bool fromActiveCampaign;
  final UserProposalOwnership ownership;

  const ProposalMenuActionButton({
    super.key,
    required this.ref,
    required this.proposalPublish,
    required this.version,
    required this.title,
    required this.hasNewerLocalIteration,
    required this.fromActiveCampaign,
    required this.ownership,
  });

  @override
  State<ProposalMenuActionButton> createState() => _ProposalMenuActionButtonState();
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
      leading: item.icon(workspace: true).buildIcon(color: item.foregroundColor(context)),
      title: Text(
        item.workspaceTitle(context, proposalPublish),
        style: context.textTheme.bodyLarge?.copyWith(
          color: item.foregroundColor(context),
        ),
      ),
      mouseCursor: item.clickable ? SystemMouseCursors.click : null,
    );
  }
}

class _ProposalMenuActionButtonState extends State<ProposalMenuActionButton> {
  final GlobalKey<PopupMenuButtonState<int>> _buttonKey = GlobalKey();

  bool get _isSubmitted => widget.proposalPublish.isPublished;

  List<ProposalMenuItemAction> get _items => ProposalMenuItemAction.workspaceAvailableOptions(
    widget.proposalPublish,
    fromActiveCampaign: widget.fromActiveCampaign,
    ownership: widget.ownership,
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
          foregroundColor: _isSubmitted ? context.colors.textOnPrimaryWhite : null,
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
        context.read<WorkspaceBloc>().add(DeleteDraftProposalEvent(ref: widget.ref as DraftRef));
      }
    }
  }

  Future<void> _editProposal() async {
    if (widget.proposalPublish.isPublished) {
      final edit =
          await UnlockEditProposalDialog.show(
            context: context,
            title: widget.title,
            version: widget.version,
          ) ??
          false;
      if (edit && mounted) {
        context.read<WorkspaceBloc>().add(UnlockProposalEvent(widget.ref));
      }
    } else if (widget.hasNewerLocalIteration) {
      return _showLatestLocalProposalWarningSnackbar();
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

  Future<void> _leaveProposal() async {
    final action = await LeaveProposalDialog.show(
      context: context,
    );

    if (action && mounted) {
      context.read<WorkspaceBloc>().add(LeaveProposalEvent(widget.ref));
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
      case ProposalMenuItemAction.leave:
        unawaited(_leaveProposal());
      case _:
        break;
    }
  }

  void _shareProposal() {
    unawaited(ShareProposalDialog.show(context, ref: widget.ref));
  }

  void _showLatestLocalProposalWarningSnackbar() {
    VoicesSnackBar.hideCurrent(context);

    VoicesSnackBar(
      type: VoicesSnackBarType.warning,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.cantEditThisProposal,
      message: context.l10n.deleteLocalVersionIfWantToPublishThisVersion,
      duration: const Duration(seconds: 6),
    ).show(context);
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }

  void _viewProposal() {
    unawaited(ProposalRoute.fromRef(ref: widget.ref).push(context));
  }
}

extension on ProposalMenuItemAction {
  Color? foregroundColor(BuildContext context) {
    return switch (this) {
      ProposalMenuItemAction.leave => context.colors.iconsError,
      _ => null,
    };
  }
}
