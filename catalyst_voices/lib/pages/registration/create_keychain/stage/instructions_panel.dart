import 'package:catalyst_voices/pages/registration/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InstructionsPanel extends StatelessWidget {
  const InstructionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Expanded(
          child: SingleChildScrollView(
            child: RegistrationStageMessage(
              title: Text(l10n.accountInstructionsTitle),
              subtitle: Text(l10n.accountInstructionsMessage),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const RegistrationBackNextNavigation(),
      ],
    );
  }
}
