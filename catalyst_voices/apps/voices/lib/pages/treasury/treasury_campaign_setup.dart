import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
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
    return SectionExpandableTile<CampaignSetup, DummyTopicStep>(
      section: data,
      stepBuilder: (context, step, state) {
        return _StepDetails(
          key: ValueKey('WorkspaceStep${step.id}TileKey'),
          id: step.id,
          name: step.localizedName(context),
          desc: step.localizedDesc(context),
          isSelected: state.isSelected,
          isEditable: step.isEditable,
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
