import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WorkspaceFormSection extends StatelessWidget {
  final WorkspaceSection data;

  const WorkspaceFormSection({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SectionsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final isOpened = value.openedSections.contains(data.id);
        final hasSelectedStep = value.activeSectionId == data.id;
        final activeStepId = value.activeStepId;

        return Column(
          children: <Widget>[
            SegmentHeader(
              leading: ChevronExpandButton(
                onTap: () => controller.toggleSection(data.id),
                isExpanded: isOpened,
              ),
              name: data.localizedName(context),
              isSelected: isOpened && hasSelectedStep,
            ),
            if (isOpened)
              ...data.steps.whereType<RichTextStep>().map(
                (step) {
                  final stepId = (sectionId: data.id, stepId: step.id);

                  return _StepDetails(
                    key: ValueKey('WorkspaceStep${step.id}TileKey'),
                    step: step,
                    isSelected: activeStepId == stepId,
                    isEditable: step.isEditable,
                  );
                },
              ),
          ].separatedBy(const SizedBox(height: 12)).toList(),
        );
      },
    );
  }
}

class _StepDetails extends StatelessWidget {
  final RichTextStep step;
  final bool isSelected;
  final bool isEditable;

  const _StepDetails({
    super.key,
    required this.step,
    this.isSelected = false,
    this.isEditable = false,
  });

  @override
  Widget build(BuildContext context) {
    return WorkspaceTileContainer(
      isSelected: isSelected,
      content: VoicesRichText(
        title: step.localizedDesc(context),
        document: Document.fromJson(step.data.value),
        charsLimit: step.charsLimit,
      ),
    );
  }
}
