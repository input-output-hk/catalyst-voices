import 'package:catalyst_voices_blocs/src/registration/registration_navigator.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class WalletLinkController {}

final class RegistrationWalletLinkController
    implements WalletLinkController, RegistrationNavigator<WalletLink> {
  WalletLinkStage _stage;

  RegistrationWalletLinkController({
    WalletLinkStage stage = WalletLinkStage.intro,
  }) : _stage = stage;

  @override
  WalletLink? nextStep() {
    final nextStep = switch (_stage) {
      WalletLinkStage.intro =>
        const WalletLink(stage: WalletLinkStage.selectWallet),
      WalletLinkStage.selectWallet => null,
    };

    if (nextStep != null) {
      _stage = nextStep.stage;
    }

    return nextStep;
  }

  @override
  WalletLink? previousStep() {
    final previousStep = switch (_stage) {
      WalletLinkStage.intro => null,
      WalletLinkStage.selectWallet =>
        const WalletLink(stage: WalletLinkStage.intro),
    };

    if (previousStep != null) {
      _stage = previousStep.stage;
    }

    return previousStep;
  }
}
