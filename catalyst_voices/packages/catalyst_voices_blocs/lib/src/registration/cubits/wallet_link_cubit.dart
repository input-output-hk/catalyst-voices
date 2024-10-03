import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

final class WalletLinkCubit extends Cubit<WalletLink> {
  WalletLinkCubit() : super(const WalletLink());

  set _stateData(WalletLinkStateData newValue) {
    emit(state.copyWith(stateData: newValue));
  }

  WalletLinkStateData get _stateData => state.stateData;

  void changeStage(WalletLinkStage newValue) {
    if (state.stage != newValue) {
      emit(state.copyWith(stage: newValue));
    }
  }

  Future<void> refreshWallets() async {
    try {
      _stateData = _stateData.copyWith(wallets: const Optional.empty());

      final wallets =
          await CatalystCardano.instance.getWallets().withMinimumDelay();

      _stateData = _stateData.copyWith(wallets: Optional(Success(wallets)));
    } on Exception catch (error, stackTrace) {
      _logger.severe('refreshWallets', error, stackTrace);
      _stateData = _stateData.copyWith(wallets: Optional(Failure(error)));
    }
  }

  Future<void> selectWallet(CardanoWallet wallet) async {
    try {
      final enabledWallet = await wallet.enable();
      final balance = await enabledWallet.getBalance();
      final address = await enabledWallet.getChangeAddress();

      final walletDetails = CardanoWalletDetails(
        wallet: wallet,
        balance: balance.coin,
        address: address,
      );

      final nextState = state.copyWith(
        stage: WalletLinkStage.walletDetails,
        stateData: _stateData.copyWith(
          selectedWallet: Optional(walletDetails),
        ),
      );

      emit(nextState);
    } catch (error, stackTrace) {
      _logger.severe('selectWallet', error, stackTrace);
    }
  }

  void selectRoles(Set<AccountRole> roles) {
    _stateData = _stateData.copyWith(selectedRoles: Optional(roles));
  }

  WalletLinkStep? nextStep() {
    final currentStageIndex = WalletLinkStage.values.indexOf(state.stage);
    final isLast = currentStageIndex == WalletLinkStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = WalletLinkStage.values[currentStageIndex + 1];
    return WalletLinkStep(stage: nextStage);
  }

  WalletLinkStep? previousStep() {
    final currentStageIndex = WalletLinkStage.values.indexOf(state.stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = WalletLinkStage.values[currentStageIndex - 1];
    return WalletLinkStep(stage: previousStage);
  }
}
