import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final Section section;

  const SectionHeader({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SectionsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final isOpened = value.openedSections.contains(section.id);
        final hasSelectedStep = value.activeSectionId == section.id;

        return SegmentHeader(
          leading: ChevronExpandButton(
            onTap: () => controller.toggleSection(section.id),
            isExpanded: isOpened,
          ),
          name: section.localizedName(context),
          isSelected: isOpened && hasSelectedStep,
          onTap: () {
            debugPrint('Section[${section.id}] tapped');
          },
        );
      },
    );
  }
}
