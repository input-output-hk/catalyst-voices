import 'package:catalyst_voices/pages/registration/create_base_profile/stage/acknowledgements_panel.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/instructions_panel.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/setup_panel.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class CreateBaseProfilePanel extends StatelessWidget {
  final CreateBaseProfileStage stage;

  const CreateBaseProfilePanel({
    super.key,
    required this.stage,
  });

  @override
  Widget build(BuildContext context) {
    return switch (stage) {
      CreateBaseProfileStage.instructions => const InstructionsPanel(),
      CreateBaseProfileStage.setup => const SetupPanel(
          key: Key('BaseProfileDetailsPanel'),
        ),
      CreateBaseProfileStage.acknowledgements => const AcknowledgementsPanel(),
    };
  }
}
