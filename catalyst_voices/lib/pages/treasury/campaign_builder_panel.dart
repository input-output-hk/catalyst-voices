import 'package:catalyst_voices/pages/treasury/campaign_segment_controller.dart';
import 'package:catalyst_voices/pages/treasury/treasury_campaign_builder_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CampaignBuilderPanel extends StatelessWidget {
  final TreasuryCampaignBuilder builder;

  const CampaignBuilderPanel({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      name: context.l10n.treasuryCampaignBuilder,
      onCollapseTap: () {},
      tabs: [
        if (builder.segments.isNotEmpty)
          SpaceSidePanelTab(
            name: context.l10n.treasuryCampaignBuilderSegments,
            body: Column(
              children: builder.segments.map(
                (segment) {
                  return _CampaignSegmentBody(
                    key: ValueKey('CampaignSegment${segment.id}Key'),
                    segment: segment,
                    controller: CampaignControllerScope.of(
                      context,
                      id: segment.id,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
      ],
    );
  }
}

class _CampaignSegmentBody extends StatelessWidget {
  final TreasuryCampaignSegment segment;
  final VoicesNodeMenuController? controller;

  const _CampaignSegmentBody({
    super.key,
    required this.segment,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesNodeMenu(
      name: segment.localizedName(l10n),
      controller: controller,
      items: segment.steps.map(
        (step) {
          return VoicesNodeMenuItem(
            id: step.id,
            label: step.localizedName(l10n),
          );
        },
      ).toList(),
    );
  }
}
