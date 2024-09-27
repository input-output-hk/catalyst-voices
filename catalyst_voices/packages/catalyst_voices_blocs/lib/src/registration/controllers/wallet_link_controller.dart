import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

abstract interface class WalletLinkController {}

final class RegistrationWalletLinkController
    with ChangeNotifier
    implements WalletLinkController {
  RegistrationWalletLinkController();

  WalletLink buildState(WalletLinkStage stage) {
    return WalletLink(
      stage: stage,
    );
  }

  WalletLinkStep? nextStep(WalletLinkStage stage) {
    final currentStageIndex = WalletLinkStage.values.indexOf(stage);
    final isLast = currentStageIndex == WalletLinkStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = WalletLinkStage.values[currentStageIndex + 1];
    return WalletLinkStep(stage: nextStage);
  }

  WalletLinkStep? previousStep(WalletLinkStage stage) {
    final currentStageIndex = WalletLinkStage.values.indexOf(stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = WalletLinkStage.values[currentStageIndex - 1];
    return WalletLinkStep(stage: previousStage);
  }
}
