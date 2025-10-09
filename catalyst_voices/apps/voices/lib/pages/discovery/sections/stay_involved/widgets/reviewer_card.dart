import 'dart:async';

import 'package:catalyst_voices/pages/discovery/sections/session_account_catalyst_id.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/copy_catalyst_id_tip.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/stay_involved_action_button.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/stay_involved_card.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/widgets/timeline_card.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewerCard extends StatelessWidget {
  const ReviewerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StayInvolvedCard(
      icon: VoicesAssets.icons.clipboardCheck,
      title: context.l10n.becomeReviewer,
      description: context.l10n.stayInvolvedReviewerDescription,
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const _ReviewTimeline(),
          const CopyCatalystIdTip(),
          const SessionAccountCatalystId(
            padding: EdgeInsets.only(top: 20),
          ),
          StayInvolvedActionButton(
            title: context.l10n.becomeReviewer,
            onTap: () {
              final shareManager = ShareManager.of(context);
              final uri = shareManager.becomeReviewer();
              unawaited(launchUrl(uri));
            },
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
          ),
        ],
      ),
    );
  }
}

class _ReviewTimeline extends StatelessWidget {
  const _ReviewTimeline();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<DiscoveryCubit, DiscoveryState, CampaignDatesEventsState>(
      selector: (state) => state.campaign.datesEvents,
      builder: (context, campaignDates) {
        final timelineItems = campaignDates.reviewTimelineItems;
        if (timelineItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return TimelineCard(timelineItems: timelineItems);
      },
    );
  }
}
