import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DiscoveryDrawerMenu extends StatelessWidget {
  const DiscoveryDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('DiscoveryDrawerMenuItems'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceHeader(Space.discovery),
        VoicesNavTile(
          key: const ValueKey('DiscoveryDashboardTile'),
          leading: VoicesAssets.icons.home.buildIcon(),
          name: 'Discovery Dashboard',
          backgroundColor: Space.discovery.backgroundColor(context),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        const VoicesDivider(),
        VoicesNavTile(
          key: const ValueKey('RolesTile'),
          leading: VoicesAssets.icons.user.buildIcon(),
          name: 'Catalyst Roles',
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          key: const ValueKey('FeedbackTile'),
          leading: VoicesAssets.icons.annotation.buildIcon(),
          name: 'Feedback',
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        const VoicesDivider(),
        VoicesNavTile(
          key: const ValueKey('DocumentationTile'),
          leading: VoicesAssets.icons.arrowRight.buildIcon(),
          name: 'Catalyst Gitbook documentation',
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
      ],
    );
  }
}
