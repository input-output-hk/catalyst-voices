import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'account_create_step.dart';
part 'account_recover_step.dart';
part 'wallet_drep_link_step.dart';

final class AccountCompletedStep extends RegistrationStep {
  const AccountCompletedStep();
}

final class GetStartedStep extends RegistrationStep {
  const GetStartedStep();
}

/// Represents only step of registration, not stage of this step.
sealed class RegistrationStep extends Equatable {
  const RegistrationStep();

  bool get isRecoverFlow => this is RecoverWithSeedPhraseStep;

  bool get isRegistrationFlow {
    return this is AccountCreateStep || this is AccountCreateProgressStep;
  }

  bool get isWalletDrepLinkFlow {
    return this is WalletDrepLinkStep;
  }

  bool get isWalletLinkFlow {
    return this is WalletLinkStep;
  }

  @override
  List<Object?> get props => [];
}
