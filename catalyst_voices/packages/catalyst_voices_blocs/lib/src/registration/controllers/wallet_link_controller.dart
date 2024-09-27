import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/foundation.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkController with ChangeNotifier {
  Result<List<CardanoWallet>, Exception>? _wallets;

  void handleEvent(WalletLinkEvent event) {
    switch (event) {
      case RefreshCardanoWalletsEvent():
        unawaited(_refreshCardanoWallets());
    }
  }

  WalletLink buildState(WalletLinkStage stage) {
    return WalletLink(
      stage: stage,
      state: WalletLinkStateData(
        wallets: _wallets,
      ),
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

  Future<void> _refreshCardanoWallets() async {
    try {
      _wallets = null;
      notifyListeners();

      final wallets =
          await CatalystCardano.instance.getWallets().withMinimumDelay();
      _wallets = Success(wallets);
      notifyListeners();
    } on Exception catch (error) {
      _wallets = Failure(error);
      notifyListeners();
    }
  }
}
