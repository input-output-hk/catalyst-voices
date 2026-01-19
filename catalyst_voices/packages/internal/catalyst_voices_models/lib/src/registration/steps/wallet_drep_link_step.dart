part of 'registration_step.dart';

final class WalletDrepLinkCompletedStep extends RegistrationStep {
  const WalletDrepLinkCompletedStep();
}

final class WalletDrepLinkStep extends RegistrationStep {
  final WalletDrepLinkStage stage;

  const WalletDrepLinkStep({
    this.stage = WalletDrepLinkStage.rolesConfirmation,
  });

  @override
  @mustCallSuper
  List<Object?> get props => [...super.props, stage];
}
