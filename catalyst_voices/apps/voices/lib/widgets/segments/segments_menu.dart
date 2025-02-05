import 'package:catalyst_voices/widgets/menu/voices_node_menu.dart';
import 'package:catalyst_voices/widgets/segments/segments_controller.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SegmentsMenuListener extends StatelessWidget {
  final SegmentsController controller;

  const SegmentsMenuListener({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        return SegmentsMenu(
          segments: value.segments,
          openedSegments: value.openedSegments,
          selectedSectionId: value.activeSectionId,
          onSegmentTap: controller.toggleSegment,
          onSectionSelected: controller.selectSectionStep,
        );
      },
    );
  }
}

class SegmentsMenu extends StatelessWidget {
  final List<Segment> segments;
  final Set<NodeId> openedSegments;
  final NodeId? selectedSectionId;
  final ValueChanged<NodeId> onSegmentTap;
  final ValueChanged<NodeId> onSectionSelected;

  const SegmentsMenu({
    super.key,
    required this.segments,
    this.openedSegments = const {},
    this.selectedSectionId,
    required this.onSegmentTap,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: segments.map(
        (segment) {
          return VoicesNodeMenu(
            key: ValueKey('Segment[${segment.id}]NodeMenu'),
            name: segment.resolveTitle(context),
            icon: segment.icon.buildIcon(),
            onHeaderTap: () {
              onSegmentTap(segment.id);
            },
            onItemTap: (id) {
              final sections = segment.sections;
              final section = sections.firstWhere((e) => e.id.value == id);

              onSectionSelected(section.id);
            },
            selectedItemId: selectedSectionId?.value,
            isExpanded: openedSegments.contains(segment.id),
            items: segment.sections.map(
              (section) {
                return VoicesNodeMenuItem(
                  id: section.id.value,
                  label: section.resolveTitle(context),
                  isEnabled: section.isEnabled,
                );
              },
            ).toList(),
          );
        },
      ).toList(),
    );
  }
}
