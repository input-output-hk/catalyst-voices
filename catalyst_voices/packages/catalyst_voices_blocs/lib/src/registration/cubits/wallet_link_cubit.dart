import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkCubit extends Cubit<WalletLink> {
  WalletLinkStage _stage;
  Result<List<CardanoWallet>, Exception>? _wallets;

  WalletLinkCubit()
      : _stage = WalletLinkStage.intro,
        super(const WalletLink());

  void changeStage(WalletLinkStage newValue) {
    if (_stage != newValue) {
      _stage = newValue;
      emit(_buildState());
    }
  }

  Future<void> refreshCardanoWallets() async {
    try {
      _wallets = null;
      emit(_buildState());

      final wallets =
          await CatalystCardano.instance.getWallets().withMinimumDelay();
      _wallets = Success(wallets);
      emit(_buildState());
    } on Exception catch (error) {
      _wallets = Failure(error);
      emit(_buildState());
    }
  }

  WalletLinkStep? nextStep() {
    final currentStageIndex = WalletLinkStage.values.indexOf(_stage);
    final isLast = currentStageIndex == WalletLinkStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = WalletLinkStage.values[currentStageIndex + 1];
    return WalletLinkStep(stage: nextStage);
  }

  WalletLinkStep? previousStep() {
    final currentStageIndex = WalletLinkStage.values.indexOf(_stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = WalletLinkStage.values[currentStageIndex - 1];
    return WalletLinkStep(stage: previousStage);
  }

  WalletLink _buildState() {
    return WalletLink(
      stage: _stage,
      state: WalletLinkStateData(
        wallets: _wallets,
      ),
    );
  }
}
