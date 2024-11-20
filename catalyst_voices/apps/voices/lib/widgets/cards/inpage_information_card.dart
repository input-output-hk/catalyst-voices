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
    return SizedBox(
      width: 500,
      child: DecoratedBox(
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
                          information.stageTranslation(context.l10n),
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          information.description,
                          style: textTheme.bodyMedium,
                        ),
                        _CampaignDateInformation(information: information),
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
                  child: Text(context.l10n.viewProposals),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CampaignDateInformation extends StatelessWidget {
  final InPageInformation information;

  const _CampaignDateInformation({required this.information});

  @override
  Widget build(BuildContext context) {
    return switch (information) {
      final LiveCampaignInformation _ ||
      final DraftCampaignInformation _ =>
        Column(
          children: [
            const SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                VoicesAssets.icons.calendar.buildIcon(),
                const SizedBox(width: 8),
                Text(
                  (information as DateTimeMixin).getFormattedDate(context.l10n),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
