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
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceHeader(Space.discovery),
        VoicesNavTile(
          leading: VoicesAssets.icons.home.buildIcon(),
          name: 'Discovery Dashboard',
          backgroundColor: Space.discovery.backgroundColor(context),
        ),
        const VoicesDivider(),
        VoicesNavTile(
          leading: VoicesAssets.icons.user.buildIcon(),
          name: 'Catalyst Roles',
        ),
        VoicesNavTile(
          leading: VoicesAssets.icons.annotation.buildIcon(),
          name: 'Feedback',
        ),
        const VoicesDivider(),
        VoicesNavTile(
          leading: VoicesAssets.icons.arrowRight.buildIcon(),
          name: 'Catalyst Gitbook documentation',
        ),
      ],
    );
  }
}
