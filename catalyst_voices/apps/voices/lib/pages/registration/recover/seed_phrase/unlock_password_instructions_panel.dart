import 'package:catalyst_voices/pages/registration/widgets/registration_stage_message.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UnlockPasswordInstructionsPanel extends StatelessWidget {
  const UnlockPasswordInstructionsPanel({
    super.key,
  });

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
              title: Text(l10n.recoveryUnlockPasswordInstructionsTitle),
              subtitle: Text(
                l10n.recoveryUnlockPasswordInstructionsSubtitle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const RegistrationBackNextNavigation(),
      ],
    );
  }
}
