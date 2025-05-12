import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalSegmentsNavigation extends StatelessWidget {
  const ProposalSegmentsNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, _) {
        return _ProposalSegmentsNavigation(
          segments: value.segments,
          openedSegments: value.openedSegments,
          selectedSectionId: value.activeSectionId,
        );
      },
    );
  }
}

class _ProposalSegmentsNavigation extends StatelessWidget {
  final List<Segment> segments;
  final Set<NodeId> openedSegments;
  final NodeId? selectedSectionId;

  const _ProposalSegmentsNavigation({
    required this.segments,
    this.openedSegments = const {},
    this.selectedSectionId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        final segment = segments[index];

        return _SegmentMenuTile(
          key: ValueKey('Segment[$index]NodeMenu'),
          segment: segment,
          isExpanded: openedSegments.contains(segment.id),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: segments.length,
    );
  }
}

class _SegmentMenuTile extends StatelessWidget {
  final Segment segment;
  final bool isExpanded;

  const _SegmentMenuTile({
    required super.key,
    required this.segment,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesNodeMenu(
      key: ValueKey('Segment[${segment.id}]NodeMenu'),
      name: Text(segment.resolveTitle(context)),
      icon: segment.icon.buildIcon(),
      onHeaderTap: () {
        SegmentsControllerScope.of(context).toggleSegment(segment.id);
      },
      onItemTap: (id) {
        final sections = segment.sections;
        final section = sections.firstWhere((e) => e.id.value == id);

        SegmentsControllerScope.of(context).selectSectionStep(section.id);
      },
      isExpanded: isExpanded,
      items: segment.sections.map(
        (section) {
          return VoicesNodeMenuItem(
            id: section.id.value,
            label: section.resolveTitle(context),
            isEnabled: section.isEnabled,
            hasError: section.hasError,
          );
        },
      ).toList(),
    );
  }
}
