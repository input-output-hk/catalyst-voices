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
        SectionHeader(
          leading: SizedBox(width: 12),
          title: Text('Individual private campaigns'),
        ),
        VoicesDrawerNavItem(
          name: 'Fund name 1',
          status: ProposalStatus.ready,
        ),
        VoicesDrawerNavItem(
          name: 'Campaign 1',
          status: ProposalStatus.draft,
        ),
        VoicesDrawerNavItem(
          name: 'What happens with a campaign title that is longer that',
          status: ProposalStatus.draft,
        ),
      ],
    );
  }
}
