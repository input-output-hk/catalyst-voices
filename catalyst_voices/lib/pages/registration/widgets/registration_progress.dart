import 'package:catalyst_voices/widgets/indicators/process_progress_indicator.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

enum RegistrationProgressStepGroup {
  createKeychain,
  linkWallet,
  accountCompleted;

  String _localizedName(BuildContext context) {
    return switch (this) {
      RegistrationProgressStepGroup.createKeychain =>
        context.l10n.registrationCreateKeychainStepGroup,
      RegistrationProgressStepGroup.linkWallet =>
        context.l10n.registrationLinkWalletStepGroup,
      RegistrationProgressStepGroup.accountCompleted =>
        context.l10n.registrationCompletedStepGroup,
    };
  }

  ProcessProgressStep<RegistrationProgressStepGroup> _asProcessStep(
    BuildContext context,
  ) {
    return ProcessProgressStep(
      value: this,
      name: _localizedName(context),
    );
  }
}

class RegistrationProgressKeychainCompleted extends StatelessWidget {
  const RegistrationProgressKeychainCompleted({super.key});

  @override
  Widget build(BuildContext context) {
    return const RegistrationProgress(
      completed: {
        RegistrationProgressStepGroup.createKeychain,
      },
      current: RegistrationProgressStepGroup.linkWallet,
    );
  }
}

class RegistrationProgress extends StatelessWidget {
  final Set<RegistrationProgressStepGroup> completed;
  final RegistrationProgressStepGroup current;

  const RegistrationProgress({
    super.key,
    required this.completed,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return ProcessProgressIndicator<RegistrationProgressStepGroup>(
      steps: RegistrationProgressStepGroup.values
          .map((e) => e._asProcessStep(context))
          .toList(),
      completed: completed,
      current: current,
    );
  }
}
