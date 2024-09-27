import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_navigator.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:result_type/result_type.dart';

// ignore: one_member_abstracts
abstract interface class WalletLinkController {
  /// A value listenable with available cardano wallets.
  ValueListenable<Result<List<CardanoWallet>, Exception>?> get cardanoWallets;

  /// Refreshes the [cardanoWallets].
  Future<void> refreshCardanoWallets();
}

final class RegistrationWalletLinkController
    implements WalletLinkController, RegistrationNavigator<WalletLink> {
  final ValueNotifier<Result<List<CardanoWallet>, Exception>?> _wallets =
      ValueNotifier(null);

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

  @override
  ValueListenable<Result<List<CardanoWallet>, Exception>?> get cardanoWallets =>
      _wallets;

  @override
  Future<void> refreshCardanoWallets() async {
    try {
      _wallets.value = null;

      final wallets =
          await CatalystCardano.instance.getWallets().withMinimumDelay();
      _wallets.value = Success(wallets);
    } on Exception catch (error) {
      _wallets.value = Failure(error);
    }
  }
}
