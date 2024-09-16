import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/menu/voices_expandable_list_tile.dart';
import 'package:catalyst_voices/widgets/menu/voices_list_tile.dart';
import 'package:catalyst_voices/widgets/menu/voices_wallet_tile.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

const _base64Icon =
    'data:image/png;base64,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'
    'Jggg==';

class VoicesListTileExample extends StatelessWidget {
  static const String route = '/list-tile-example';

  const VoicesListTileExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoicesAppBar(),
      body: SizedBox(
        width: 300,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            VoicesExpandableListTile(
              title: const Text('My Dashboard'),
              leading: VoicesAssets.icons.home.buildIcon(),
              trailing: VoicesAssets.icons.eye.buildIcon(),
              expandedChildren: [
                VoicesListTile(
                  trailing: VoicesAssets.icons.eye.buildIcon(),
                  title: const Text('My Catalyst Proposals'),
                  onTap: () {},
                ),
                VoicesListTile(
                  trailing: VoicesAssets.icons.eye.buildIcon(),
                  title: const Text('My Actions'),
                  onTap: () {},
                ),
                VoicesListTile(
                  trailing: VoicesAssets.icons.eye.buildIcon(),
                  title: const Text('Catalyst Campaign Timeline'),
                  onTap: () {},
                ),
              ],
            ),
            const Divider(),
            VoicesListTile(
              leading: VoicesAssets.icons.user.buildIcon(),
              trailing: VoicesAssets.icons.eye.buildIcon(),
              title: const Text('Catalyst Roles'),
              onTap: () {},
            ),
            VoicesWalletTile(
              iconSrc: _base64Icon,
              name: const Text('Wallet Extension'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
