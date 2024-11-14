import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryDummyTopicStep extends StatelessWidget {
  final DummyTopicStep step;

  const TreasuryDummyTopicStep({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return SectionStepStateBuilder(
      id: step.sectionStepId,
      builder: (context, value, child) {
        return WorkspaceTextTileContainer(
          name: step.localizedName(context),
          isSelected: value.isSelected,
          headerActions: [
            VoicesTextButton(
              onTap: step.isEditable ? () {} : null,
              child: Text(context.l10n.stepEdit),
            ),
          ],
          content: step.localizedDesc(context),
        );
      },
    );
  }
}
