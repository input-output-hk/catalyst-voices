import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurrentCampaign extends StatelessWidget {
  final CurrentCampaignInfoViewModel currentCampaignInfo;
  final bool isLoading;

  const CurrentCampaign({
    super.key,
    required this.currentCampaignInfo,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 120, top: 64, right: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Skeletonizer(
                enabled: isLoading,
                child: FundsDetailCard(
                  key: const Key('FundsDetailCard'),
                  allFunds: currentCampaignInfo.allFunds,
                  totalAsk: currentCampaignInfo.totalAsk,
                  askRange: currentCampaignInfo.askRange,
                ),
              ),
              const SizedBox(height: 80),
              const _SubTitle(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32, bottom: 160),
          child: CampaignTimeline(
            timelineItems: CampaignTimelineViewModelX.mockData,
            placement: CampaignTimelinePlacement.discovery,
            horizontalPadding: const SizedBox(width: 120),
          ),
        ),
      ],
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 592),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            key: const Key('IdeaSubTitle'),
            context.l10n.ideaJourney,
            style: context.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          MarkdownText(MarkdownData(context.l10n.ideaJourneyDescription)),
        ],
      ),
    );
  }
}
