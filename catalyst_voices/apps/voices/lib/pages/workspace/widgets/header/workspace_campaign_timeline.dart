import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class WorkspaceCampaignTimeline extends StatelessWidget {
  const WorkspaceCampaignTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, WorkspaceStateCampaignTimeline>(
      selector: (state) {
        return state.campaignTimeline;
      },
      builder: (context, timeline) {
        return CampaignTimeline(
          timelineItems: timeline.items,
        );
      },
    );
  }
}
