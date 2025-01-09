import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SegmentHeaderTile extends StatelessWidget {
  final NodeId id;
  final String name;

  const SegmentHeaderTile({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SegmentsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final isOpened = value.openedSegments.contains(id);
        final hasSelectedStep = value.activeSectionId?.isChildOf(id) ?? false;

        return SegmentHeader(
          leading: ChevronExpandButton(
            onTap: () => controller.toggleSegment(id),
            isExpanded: isOpened,
          ),
          name: name,
          isSelected: isOpened && hasSelectedStep,
          onTap: () => controller.focusSection(id),
        );
      },
    );
  }
}
