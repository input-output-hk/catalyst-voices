import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_nav_tile.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VotingOverview extends StatelessWidget {
  const VotingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SpaceOverviewContainer(
      child: Column(
        children: [
          const SpaceOverviewHeader(Space.voting),
          const SectionHeader(title: Text('Active funding rounds')),
          VoicesNavTile(
            leading: VoicesAssets.icons.vote.buildIcon(),
            name: 'Voting round 14',
            status: ProposalStatus.open,
          ),
          const VoicesDivider(indent: 0, endIndent: 0, height: 16),
          const SectionHeader(title: Text('Funding tracks / Categories')),
          SpaceOverviewNavTile(
            leading: VoicesAssets.icons.document.buildIcon(),
            title: Text(
              'My fund 14 proposal',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const VoicesDivider(indent: 0, endIndent: 0, height: 16),
          const SectionHeader(title: Text('Dreps')),
          SpaceOverviewNavTile(
            leading: VoicesAssets.icons.user.buildIcon(),
            title: const Text('Drep signup'),
          ),
          SpaceOverviewNavTile(
            leading: VoicesAssets.icons.user.buildIcon(),
            title: const Text('Drep delegation'),
          ),
        ],
      ),
    );
  }
}
