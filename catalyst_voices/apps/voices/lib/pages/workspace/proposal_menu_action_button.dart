import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal_builder/appbar/proposal_menu_item_action_enum.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalMenuActionButton extends StatefulWidget {
  final DocumentRef ref;
  final ProposalPublish proposalPublish;
  const ProposalMenuActionButton({
    super.key,
    required this.ref,
    required this.proposalPublish,
  });

  @override
  State<ProposalMenuActionButton> createState() =>
      _ProposalMenuActionButtonState();
}

class _ProposalMenuActionButtonState extends State<ProposalMenuActionButton> {
  final GlobalKey<PopupMenuButtonState<int>> _buttonKey = GlobalKey();

  bool get isSubmitted => widget.proposalPublish.isPublished;

  List<ProposalMenuItemAction> get items =>
      ProposalMenuItemAction.availableOptions(
        widget.proposalPublish,
        workspace: true,
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
          for (final item in items)
            PopupMenuItem(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
              child: ListTile(
                leading: item.icon(workspace: true).buildIcon(),
                title: Text(
                  item.workspaceTitle(context, widget.proposalPublish),
                ),
                mouseCursor: item.clickable ? SystemMouseCursors.click : null,
              ),
            ),
        ];
      },
      child: VoicesIconButton(
        onTap: _showMenu,
        style: IconButton.styleFrom(
          foregroundColor:
              isSubmitted ? context.colors.textOnPrimaryWhite : null,
        ),
        child: VoicesAssets.icons.dotsVertical.buildIcon(),
      ),
    );
  }

  void _showMenu() {
    _buttonKey.currentState?.showButtonMenu();
  }
}
