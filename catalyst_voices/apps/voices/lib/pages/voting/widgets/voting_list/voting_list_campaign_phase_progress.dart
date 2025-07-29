import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VotingListCampaignPhaseProgress extends StatelessWidget {
  const VotingListCampaignPhaseProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          VoicesLinearProgressIndicator(),
          Row(
            children: [
              Text('Fund15 · Voting Phase'),
              Spacer(),
              Text('Ends in 20d 12h 34m'),
            ],
          )
        ],
      ),
    );
  }
}
