import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SectionStepState extends Equatable {
  final bool isSelected;

  const SectionStepState({required this.isSelected});

  @override
  List<Object?> get props => [
        isSelected,
      ];
}

typedef SectionStepWidgetBuilder<T extends SectionStep> = Widget Function(
  BuildContext context,
  T step,
  SectionStepState state,
);

class SectionExpandableTile<T extends Section, T2 extends SectionStep>
    extends StatelessWidget {
  final T section;
  final SectionStepWidgetBuilder<T2> stepBuilder;

  const SectionExpandableTile({
    super.key,
    required this.section,
    required this.stepBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SectionsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final isOpened = value.openedSections.contains(section.id);
        final hasSelectedStep = value.activeSectionId == section.id;
        final activeStepId = value.activeStepId;

        return Column(
          children: <Widget>[
            SegmentHeader(
              leading: ChevronExpandButton(
                onTap: () => controller.toggleSection(section.id),
                isExpanded: isOpened,
              ),
              name: section.localizedName(context),
              isSelected: isOpened && hasSelectedStep,
            ),
            if (isOpened)
              ...section.steps.whereType<T2>().map(
                (step) {
                  final stepId = (sectionId: section.id, stepId: step.id);
                  final isSelected = activeStepId == stepId;

                  final state = SectionStepState(
                    isSelected: isSelected,
                  );

                  return stepBuilder(context, step, state);
                },
              ),
          ].separatedBy(const SizedBox(height: 12)).toList(),
        );
      },
    );
  }
}
