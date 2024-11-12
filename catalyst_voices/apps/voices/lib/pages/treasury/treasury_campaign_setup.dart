import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryCampaignSetup extends StatelessWidget {
  final CampaignSetup data;

  const TreasuryCampaignSetup({
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
        final activeStepId = value.activeStepId;

        return Column(
          children: <Widget>[
            SegmentHeader(
              leading: ChevronExpandButton(
                onTap: () => controller.toggleSection(data.id),
                isExpanded: isOpened,
              ),
              name: data.localizedName(context),
              isSelected: activeStepId?.sectionId == data.id,
            ),
            if (isOpened)
              ...data.steps.map(
                (step) {
                  final stepId = (sectionId: data.id, stepId: step.id);

                  return _StepDetails(
                    key: ValueKey('WorkspaceStep${step.id}TileKey'),
                    id: step.id,
                    name: step.localizedName(context),
                    desc: step.localizedDesc(context),
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
  final int id;
  final String name;
  final String desc;
  final bool isSelected;
  final bool isEditable;

  const _StepDetails({
    super.key,
    required this.id,
    required this.name,
    required this.desc,
    this.isSelected = false,
    this.isEditable = false,
  });

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
