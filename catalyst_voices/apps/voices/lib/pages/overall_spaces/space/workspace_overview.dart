import 'package:catalyst_voices/pages/overall_spaces/space/space_overview_header.dart';
import 'package:catalyst_voices/pages/overall_spaces/space_overview_container.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class WorkspaceOverview extends StatelessWidget {
  const WorkspaceOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpaceOverviewContainer(
      child: Column(
        children: [
          SpaceOverviewHeader(Space.workspace),
          SectionHeader(title: Text('My private proposals (3/5)')),
          VoicesNavTile(
            name: 'My first proposal',
            status: ProposalStatus.draft,
            trailing: MoreOptionsButton(),
          ),
          VoicesNavTile(
            name: 'My second proposal',
            status: ProposalStatus.ready,
            trailing: MoreOptionsButton(),
          ),
          VoicesNavTile(
            name: 'My third proposal',
            status: ProposalStatus.ready,
            trailing: MoreOptionsButton(),
          ),
          VoicesDivider(indent: 0, endIndent: 0, height: 16),
        ],
      ),
    );
  }
}
