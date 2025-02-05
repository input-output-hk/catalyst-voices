import 'package:catalyst_voices/widgets/indicators/process_progress_indicator.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class RegistrationProgressStepper extends StatelessWidget {
  final Set<AccountCreateStepType> completed;
  final AccountCreateStepType? current;

  const RegistrationProgressStepper({
    super.key,
    required this.completed,
    this.current,
  });

  @override
  Widget build(BuildContext context) {
    final current = this.current;

    return ProcessProgressIndicator<_RegistrationProgressStep>(
      steps: [
        ...AccountCreateStepType.values.map(_AccountCreationProgress.new),
        const _AccountCompleted(),
      ].map((e) => e._toProcessProgressStep(context)).toList(),
      completed: {
        ...completed.map(_AccountCreationProgress.new),
      },
      current: current != null ? _AccountCreationProgress(current) : null,
    );
  }
}

sealed class _RegistrationProgressStep extends Equatable {
  const _RegistrationProgressStep();

  String _localizedName(BuildContext context);

  ProcessProgressStep<_RegistrationProgressStep> _toProcessProgressStep(
    BuildContext context,
  ) {
    final value = this;
    final name = _localizedName(context);
    return ProcessProgressStep(value: value, name: name);
  }
}

final class _AccountCreationProgress extends _RegistrationProgressStep {
  final AccountCreateStepType data;

  const _AccountCreationProgress(this.data);

  @override
  String _localizedName(BuildContext context) {
    return data._localizedName(context);
  }

  @override
  List<Object?> get props => [data];
}

final class _AccountCompleted extends _RegistrationProgressStep {
  const _AccountCompleted();

  @override
  String _localizedName(BuildContext context) {
    return context.l10n.registrationCompletedStepGroup;
  }

  @override
  List<Object?> get props => const [];
}

extension _AccountCreateStepType on AccountCreateStepType {
  String _localizedName(BuildContext context) {
    return switch (this) {
      AccountCreateStepType.baseProfile =>
        context.l10n.registrationCreateBaseProfileStepGroup,
      AccountCreateStepType.keychain =>
        context.l10n.registrationCreateKeychainStepGroup,
      AccountCreateStepType.walletLink =>
        context.l10n.registrationLinkWalletStepGroup,
    };
  }
}
