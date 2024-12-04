import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class TreasuryOverview extends StatelessWidget {
  const TreasuryOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SpaceOverviewHeader(Space.treasury),
            SectionHeader(title: Text('Individual private campaigns')),
            VoicesNavTile(
              name: 'Fund name 1',
              status: ProposalStatus.ready,
              trailing: MoreOptionsButton(),
            ),
            VoicesNavTile(
              name: 'Fund name 2',
              status: ProposalStatus.draft,
              trailing: MoreOptionsButton(),
            ),
            VoicesNavTile(
              name: 'Fund name 3',
              status: ProposalStatus.draft,
              trailing: MoreOptionsButton(),
            ),
            VoicesDivider(indent: 0, endIndent: 0, height: 16),
            SectionHeader(title: Text('Team private campaigns')),
            VoicesNavTile(
              name: 'Fund name',
              status: ProposalStatus.private,
              trailing: MoreOptionsButton(),
            ),
            VoicesDivider(indent: 0, endIndent: 0, height: 16),
            SectionHeader(title: Text('Public campaigns')),
            VoicesNavTile(
              name: 'Fund 14',
              status: ProposalStatus.live,
              trailing: MoreOptionsButton(),
            ),
            VoicesDivider(indent: 0, endIndent: 0, height: 16),
            SectionHeader(title: Text('Completed campaigns')),
            VoicesNavTile(
              name: 'Fund 15',
              status: ProposalStatus.completed,
              trailing: MoreOptionsButton(),
            ),
          ],
        ),
      ),
    );
  }
}
