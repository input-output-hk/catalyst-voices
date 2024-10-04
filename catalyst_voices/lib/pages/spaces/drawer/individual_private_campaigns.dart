import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class IndividualPrivateCampaigns extends StatelessWidget {
  const IndividualPrivateCampaigns({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceHeader(Space.treasury),
        const SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Individual private campaigns'),
        ),
        VoicesNavTile(
          name: 'Fund name 1',
          status: ProposalStatus.ready,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          name: 'Campaign 1',
          status: ProposalStatus.draft,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          name: 'What happens with a campaign title that is longer that',
          status: ProposalStatus.draft,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
      ],
    );
  }
}
