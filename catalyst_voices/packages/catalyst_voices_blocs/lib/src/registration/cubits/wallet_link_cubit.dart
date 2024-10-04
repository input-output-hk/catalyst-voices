import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  Future<bool> selectWallet(CardanoWallet wallet);

  void selectRoles(Set<AccountRole> roles);

  void submitRegistration();
}

final class WalletLinkCubit extends Cubit<WalletLinkStateData>
    implements WalletLinkManager {
  WalletLinkCubit() : super(const WalletLinkStateData());

  @override
  Future<void> refreshWallets() async {
    try {
      emit(state.copyWith(wallets: const Optional.empty()));

      final wallets =
          await CatalystCardano.instance.getWallets().withMinimumDelay();

      emit(state.copyWith(wallets: Optional(Success(wallets))));
    } on Exception catch (error, stackTrace) {
      _logger.severe('refreshWallets', error, stackTrace);
      emit(state.copyWith(wallets: Optional(Failure(error))));
    }
  }

  @override
  Future<bool> selectWallet(CardanoWallet wallet) async {
    try {
      final enabledWallet = await wallet.enable();
      final balance = await enabledWallet.getBalance();
      final address = await enabledWallet.getChangeAddress();

      final walletDetails = CardanoWalletDetails(
        wallet: wallet,
        balance: balance.coin,
        address: address,
      );

      emit(state.copyWith(selectedWallet: Optional(walletDetails)));

      return true;
    } catch (error, stackTrace) {
      _logger.severe('selectWallet', error, stackTrace);
      return false;
    }
  }

  @override
  void selectRoles(Set<AccountRole> roles) {
    emit(state.copyWith(selectedRoles: Optional(roles)));
  }

  @override
  void submitRegistration() {
    // TODO(dtscalac): submit RBAC transaction
  }
}
