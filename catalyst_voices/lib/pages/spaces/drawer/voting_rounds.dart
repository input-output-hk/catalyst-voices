import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VotingRounds extends StatelessWidget {
  const VotingRounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceHeader(Space.voting),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Active funding rounds'),
        ),
        VoicesNavTile(
          name: 'Voting round 14',
          status: ProposalStatus.open,
          leading: VoicesAssets.icons.vote.buildIcon(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Funding tracks / Categories'),
        ),
        VoicesNavTile(
          name: 'My first proposal',
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        const VoicesDivider(),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Dreps'),
        ),
        VoicesNavTile(
          name: 'Drep signup',
          leading: VoicesAssets.icons.user.buildIcon(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          name: 'Drep delegation',
          leading: VoicesAssets.icons.user.buildIcon(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        const VoicesDivider(),
      ],
    );
  }
}
