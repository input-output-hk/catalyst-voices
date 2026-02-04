import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/tiles/menu_item_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class MyActionsMenuItemTile extends StatelessWidget {
  final VoidCallback? onTap;

  const MyActionsMenuItemTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return state.hasProposalsActions;
      },
      builder: (context, showBadge) {
        return _MyActionsMenuItemTile(
          showBadge: showBadge,
          onTap: onTap,
        );
      },
    );
  }
}

class _Icon extends StatelessWidget {
  final bool showBadge;

  const _Icon({required this.showBadge});

  @override
  Widget build(BuildContext context) {
    return Badge(
      backgroundColor: context.colorScheme.error,
      isLabelVisible: showBadge,
      smallSize: 8,
      child: VoicesAssets.icons.fire.buildIcon(),
    );
  }
}

class _MyActionsMenuItemTile extends StatelessWidget {
  final bool showBadge;
  final VoidCallback? onTap;

  const _MyActionsMenuItemTile({
    required this.showBadge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MenuItemTile(
      key: const Key('MyActionsMenuItem'),
      title: Text(context.l10n.myActions),
      leading: _Icon(showBadge: showBadge),
      onTap: onTap,
    );
  }
}
