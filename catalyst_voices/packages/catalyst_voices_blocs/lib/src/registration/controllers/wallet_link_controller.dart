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
      WalletLinkStage.selectWallet =>
        const WalletLink(stage: WalletLinkStage.walletDetails),
      WalletLinkStage.walletDetails =>
        const WalletLink(stage: WalletLinkStage.rolesChooser),
      WalletLinkStage.rolesChooser =>
        const WalletLink(stage: WalletLinkStage.rolesSummary),
      WalletLinkStage.rolesSummary =>
        const WalletLink(stage: WalletLinkStage.rbacTransaction),
      WalletLinkStage.rbacTransaction => null,
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
      WalletLinkStage.walletDetails =>
        const WalletLink(stage: WalletLinkStage.selectWallet),
      WalletLinkStage.rolesChooser =>
        const WalletLink(stage: WalletLinkStage.walletDetails),
      WalletLinkStage.rolesSummary =>
        const WalletLink(stage: WalletLinkStage.rolesChooser),
      WalletLinkStage.rbacTransaction =>
        const WalletLink(stage: WalletLinkStage.rolesSummary),
    };

    if (previousStep != null) {
      _stage = previousStep.stage;
    }

    return previousStep;
  }
}
