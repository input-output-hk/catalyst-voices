import 'package:catalyst_voices/pages/treasury/treasury_campaign_builder_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CampaignBuilderPanel extends StatelessWidget {
  final TreasuryCampaignBuilder builder;
  final Map<Object, VoicesNodeMenuController> stepsControllers;

  const CampaignBuilderPanel({
    required this.builder,
    required this.stepsControllers,
  });

  @override
  Widget build(BuildContext context) {
    return SpaceSidePanel(
      isLeft: true,
      // TODO: loc
      name: 'Campaign builder',
      onCollapseTap: () {},
      tabs: [
        if (builder.segments.isNotEmpty)
          SpaceSidePanelTab(
            // TODO: loc
            name: 'Segments',
            body: Column(
              children: builder.segments.map(
                (segment) {
                  return _CampaignSegmentBody(
                    key: ValueKey('CampaignSegment${segment.id}Key'),
                    segment: segment,
                    controller: stepsControllers[segment.id],
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
