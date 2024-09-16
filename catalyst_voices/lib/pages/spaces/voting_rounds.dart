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
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Active funding rounds'),
        ),
        VoicesNavTile(
          name: 'Voting round 14',
          status: ProposalStatus.open,
          leading: VoicesAssets.icons.vote.buildIcon(),
        ),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Funding tracks / Categories'),
        ),
        const VoicesNavTile(
          name: 'My first proposal',
          trailing: MoreOptionsButton(),
        ),
        const VoicesDivider(),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Dreps'),
        ),
        VoicesNavTile(
          name: 'Drep signup',
          leading: VoicesAssets.icons.user.buildIcon(),
        ),
        VoicesNavTile(
          name: 'Drep delegation',
          leading: VoicesAssets.icons.user.buildIcon(),
        ),
        const VoicesDivider(),
      ],
    );
  }
}
