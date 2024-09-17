import 'package:catalyst_voices/pages/treasury/campaign_segment_controller.dart';
import 'package:catalyst_voices/pages/treasury/treasury_campaign_builder_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CampaignDetails extends StatelessWidget {
  final TreasuryCampaignBuilder builder;

  const CampaignDetails({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: builder.segments.length,
      itemBuilder: (context, index) {
        final segment = builder.segments[index];

        return _ListenableSegmentDetails(
          key: ValueKey('ListenableSegment${segment.id}DetailsKey'),
          segment: segment,
          controller: CampaignControllerScope.of(
            context,
            id: segment.id,
          ),
        );
      },
    );
  }
}

class _ListenableSegmentDetails extends StatelessWidget {
  final TreasuryCampaignSegment segment;
  final VoicesNodeMenuController controller;

  const _ListenableSegmentDetails({
    super.key,
    required this.segment,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return _SegmentDetails(
          key: ValueKey('Segment${segment.id}DetailsKey'),
          name: segment.localizedName(context.l10n),
          steps: segment.steps,
          selected: controller.selected,
          isExpanded: controller.isExpanded,
          onChevronTap: () {
            controller.isExpanded = !controller.isExpanded;
          },
        );
      },
    );
  }
}

class _SegmentDetails extends StatelessWidget {
  final String name;
  final List<TreasuryCampaignSegmentStep> steps;
  final int? selected;
  final bool isExpanded;
  final VoidCallback? onChevronTap;

  const _SegmentDetails({
    super.key,
    required this.name,
    required this.steps,
    this.selected,
    this.isExpanded = false,
    this.onChevronTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SegmentHeader(
          leading: ChevronExpandButton(
            onTap: onChevronTap,
            isExpanded: isExpanded,
          ),
          name: name,
          isSelected: isExpanded,
        ),
        if (isExpanded)
          ...steps.map(
            (step) {
              return _StepDetails(
                key: ValueKey('WorkspaceStep${step.id}TileKey'),
                id: step.id,
                name: step.localizedName(context.l10n),
                desc: step.tempDescription(),
                isSelected: step.id == selected,
                isEditable: step.isEditable,
              );
            },
          ),
      ].separatedBy(const SizedBox(height: 12)).toList(),
    );
  }
}

class _StepDetails extends StatelessWidget {
  const _StepDetails({
    super.key,
    required this.id,
    required this.name,
    required this.desc,
    this.isSelected = false,
    this.isEditable = false,
  });

  final int id;
  final String name;
  final String desc;
  final bool isSelected;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    return WorkspaceTextTileContainer(
      name: name,
      isSelected: isSelected,
      headerActions: [
        VoicesTextButton(
          onTap: isEditable ? () {} : null,
          child: Text(context.l10n.stepEdit),
        ),
      ],
      content: desc,
    );
  }
}
