import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'account_create_step.dart';
part 'account_recover_step.dart';

/// Represents only step of registration, not stage of this step.
sealed class RegistrationStep extends Equatable {
  const RegistrationStep();

  bool get isRegistrationFlow => this is AccountCreateStep;

  bool get isRecoverFlow => this is RecoverWithSeedPhraseStep;

  @override
  List<Object?> get props => [];
}

final class GetStartedStep extends RegistrationStep {
  const GetStartedStep();
}

final class AccountCompletedStep extends RegistrationStep {
  const AccountCompletedStep();
}
