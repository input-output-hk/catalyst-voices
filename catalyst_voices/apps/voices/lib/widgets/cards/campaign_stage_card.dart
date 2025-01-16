import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignStageCard extends StatelessWidget {
  final CampaignInfo campaign;

  const CampaignStageCard({
    super.key,
    required this.campaign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        border: Border.all(
          color: theme.colors.outlineBorderVariant,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VoicesAvatar(
                  icon: VoicesAssets.icons.speakerphone.buildIcon(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.stage.localizedName(context.l10n),
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        campaign.description,
                        style: textTheme.bodyMedium,
                      ),
                      if (_getDateInformation(context).isNotEmpty)
                        _CampaignDateInformation(
                          value: _getDateInformation(context),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            if (campaign.stage == CampaignStage.live) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                // TODO(LynxLynxx): add logic
                onPressed: () {},
                child: Text(context.l10n.viewProposals),
              ),
            ] else if (campaign.stage == CampaignStage.completed) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                // TODO(LynxLynxx): add logic
                onPressed: () {},
                child: Text(context.l10n.viewVotingResults),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getDateInformation(BuildContext context) {
    switch (campaign.stage) {
      case CampaignStage.draft:
      case CampaignStage.scheduled:
        final formattedDate =
            DateFormatter.formatDateTimeParts(campaign.startDate);
        return context.l10n
            .campaignBeginsOn(formattedDate.$1, formattedDate.$2);
      case CampaignStage.live:
        final formattedDate =
            DateFormatter.formatDateTimeParts(campaign.endDate);
        return context.l10n.campaignEndsOn(formattedDate.$1, formattedDate.$2);
      case CampaignStage.completed:
        return '';
    }
  }
}

class _CampaignDateInformation extends StatelessWidget {
  final String value;

  const _CampaignDateInformation({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VoicesAssets.icons.calendar.buildIcon(),
            const SizedBox(width: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
