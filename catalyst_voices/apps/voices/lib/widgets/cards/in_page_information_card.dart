import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class InPageInformationCard extends StatelessWidget {
  final InPageInformation information;

  const InPageInformationCard({
    super.key,
    required this.information,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.elevationsOnSurfaceNeutralLv1White,
        border: Border.all(
          color: theme.colors.outlineBorderVariant!,
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
                        information.stage.localizedName(context.l10n),
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        information.description,
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
            if (!information.stage.isDraft) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {}, // TODO(ryszard-schossler): add logic
                child: Text(_getButtonText(context)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getButtonText(BuildContext context) {
    if (information.stage == CampaignStage.live) {
      return context.l10n.viewProposals;
    } else {
      return context.l10n.viewVotingResults;
    }
  }

  String _getDateInformation(BuildContext context) {
    if (information is LiveCampaignInformation ||
        information is DraftCampaignInformation) {
      final dateMixin = (information as DateTimeMixin);
      final formattedDate = DateFormatter.formatDateTimeParts(dateMixin.date);
      return dateMixin.localizedDate(
        context.l10n,
        formattedDate,
      );
    } else {
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