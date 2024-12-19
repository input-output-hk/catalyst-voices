import 'package:catalyst_voices/pages/spaces/drawer/space_header.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class MyPrivateProposals extends StatelessWidget {
  const MyPrivateProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SpaceHeader(Space.workspace),
        const SectionHeader(
          key: ValueKey('Header.workspace'),
          leading: SizedBox(width: 12),
          title: Text('My private proposals (3/5)'),
        ),
        VoicesNavTile(
          name: 'My first proposal',
          status: ProposalStatus.draft,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          name: 'My second proposal',
          status: ProposalStatus.inProgress,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
        VoicesNavTile(
          name: 'My third proposal',
          status: ProposalStatus.inProgress,
          trailing: const MoreOptionsButton(),
          onTap: () => Scaffold.of(context).closeDrawer(),
        ),
      ],
    );
  }
}
