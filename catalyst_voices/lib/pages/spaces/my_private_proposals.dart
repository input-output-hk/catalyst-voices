import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class MyPrivateProposals extends StatelessWidget {
  const MyPrivateProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('My private proposals (3/5)'),
        ),
        VoicesNavTile(
          name: 'My first proposal',
          status: ProposalStatus.draft,
          trailing: MoreOptionsButton(),
        ),
        VoicesNavTile(
          name: 'My second proposal',
          status: ProposalStatus.inProgress,
          trailing: MoreOptionsButton(),
        ),
        VoicesNavTile(
          name: 'My third proposal',
          status: ProposalStatus.inProgress,
          trailing: MoreOptionsButton(),
        ),
      ],
    );
  }
}
