import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/stay_involved_action_button.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/stay_involved_card.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/timeline_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VoterCard extends StatelessWidget {
  const VoterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StayInvolvedCard(
      icon: VoicesAssets.icons.vote,
      title: context.l10n.registerToVoteFund14,
      description: context.l10n.stayInvolvedContributorDescription,
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const _VotingTimeline(),
          StayInvolvedActionButton(
            title: context.l10n.becomeVoter,
            onTap: () {
              final uri = Uri.parse(VoicesConstants.afterSubmissionUrl);
              unawaited(launchUrl(uri));
            },
          ),
        ],
      ),
    );
  }
}

class _VotingTimeline extends StatelessWidget {
  const _VotingTimeline();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, List<CampaignTimelineEventWithTitle>>(
      selector: (state) => state.campaign.datesEvents.votingTimelineItems,
      builder: (context, timelineItems) {
        if (timelineItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return TimelineCard(timelineItems: timelineItems);
      },
    );
  }
}
