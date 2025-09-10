import 'package:catalyst_voices/pages/registration/registration_details_panel.dart';
import 'package:catalyst_voices/pages/registration/registration_info_panel.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class RegistrationPanelsDialog extends StatelessWidget {
  const RegistrationPanelsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RegistrationCubit, RegistrationState, bool>(
      selector: (state) {
        final isAccountCompleted = state.step.isAccountCompleted;
        final isRecovered = state.step.isRecoverWithSeedPhraseSuccess;

        return [isAccountCompleted, isRecovered].none((value) => value);
      },
      builder: (context, showCloseButton) {
        return VoicesPanelsDialog(
          key: const Key('RegistrationDialog'),
          first: const RegistrationInfoPanel(),
          second: const RegistrationDetailsPanel(),
          showClose: showCloseButton,
        );
      },
    );
  }
}

extension on RegistrationStep {
  bool get isAccountCompleted {
    return this is AccountCompletedStep;
  }

  bool get isRecoverWithSeedPhraseSuccess {
    return this == const RecoverWithSeedPhraseStep(stage: RecoverWithSeedPhraseStage.success);
  }
}
