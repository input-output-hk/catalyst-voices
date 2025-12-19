import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/tiles/menu_item_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class MyActionsMenuItemTile extends StatelessWidget {
  const MyActionsMenuItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuItemTile(
      key: const Key('MyActionsMenuItem'),
      title: Text(context.l10n.myActions),
      leading: const _Icon(showBadge: true),
      onTap: () => {},
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
