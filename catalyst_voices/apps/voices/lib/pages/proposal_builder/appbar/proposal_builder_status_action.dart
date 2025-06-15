import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/widget/proposal_builder_menu_item.dart';
import 'package:catalyst_voices/widgets/modals/proposals/proposal_builder_delete_confirmation_dialog.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart'
    show ProposalBuilderMenuItemData, ProposalMenuItemAction;
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
    final bloc = context.read<ProposalBuilderBloc>();

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
              child: BlocSelector<ProposalBuilderBloc, ProposalBuilderState,
                  ProposalBuilderMenuItemData>(
                bloc: bloc,
                selector: (state) => state.buildMenuItem(action: item),
                builder: (context, itemData) {
                  return ProposalBuilderMenuItem(data: itemData);
                },
              ),
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
    context.read<ProposalBuilderBloc>().add(ExportProposalEvent(filePrefix: prefix));
  }

  void _onSelected(ProposalMenuItemAction item) {
    switch (item) {
      case ProposalMenuItemAction.publish:
        context.read<ProposalBuilderBloc>().add(const RequestPublishProposalEvent());
      case ProposalMenuItemAction.submit:
        context.read<ProposalBuilderBloc>().add(const RequestSubmitProposalEvent());
      case ProposalMenuItemAction.export:
        _exportProposal();
      case ProposalMenuItemAction.delete:
        unawaited(_deleteProposal());
      case _:
        break;
    }
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }
}
