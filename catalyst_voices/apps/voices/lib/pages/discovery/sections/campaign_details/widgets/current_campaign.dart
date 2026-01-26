import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' show MarkdownData;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsivePadding(
          xs: const EdgeInsets.only(left: 20, top: 32, right: 20),
          sm: const EdgeInsets.only(left: 42, top: 64, right: 42),
          md: const EdgeInsets.only(left: 120, top: 64, right: 120),
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
                ),
              ),
              ResponsiveChild(
                xs: const SizedBox(height: 30),
                sm: const SizedBox(height: 48),
                md: const SizedBox(height: 80),
              ),
              const _SubTitle(),
            ],
          ),
        ),
        ResponsivePadding(
          xs: const EdgeInsets.only(top: 20, bottom: 32),
          sm: const EdgeInsets.only(top: 32, bottom: 48),
          md: const EdgeInsets.only(top: 32, bottom: 100),
          child: CampaignTimeline(
            key: const Key('CampaignTimeline'),
            timelineItems: currentCampaignInfo.timeline,
            horizontalPadding: ResponsiveChild(
              xs: const SizedBox(width: 20),
              sm: const SizedBox(width: 48),
              md: const SizedBox(width: 120),
            ),
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
          MarkdownText(
            key: const Key('IdeaDescription'),
            MarkdownData(context.l10n.ideaJourneyDescription(VoicesConstants.campaignTimeline)),
          ),
        ],
      ),
    );
  }
}
