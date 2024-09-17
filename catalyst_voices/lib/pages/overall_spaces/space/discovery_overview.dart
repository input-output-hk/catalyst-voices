import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DiscoveryOverview extends StatelessWidget {
  const DiscoveryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        children: [
          SpaceOverviewHeader(Space.discovery),
          _DiscoveryDashboardTile(),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          _RolesTile(),
          _FeedbackTile(),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
          _DocumentationTile(),
        ],
      ),
    );
  }
}

class _DiscoveryDashboardTile extends StatelessWidget {
  const _DiscoveryDashboardTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.home.buildIcon(),
      title: Text(
        'Discovery Dashboard',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      backgroundColor: Space.discovery.backgroundColor(context),
    );
  }
}

class _RolesTile extends StatelessWidget {
  const _RolesTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.user.buildIcon(),
      title: const Text('Catalyst Roles'),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.annotation.buildIcon(),
      title: const Text('Feedback'),
    );
  }
}

class _DocumentationTile extends StatelessWidget {
  const _DocumentationTile();

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewNavTile(
      leading: VoicesAssets.icons.arrowRight.buildIcon(),
      title: const Text('Catalyst Gitbook documentation'),
    );
  }
}
