import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  Future<bool> selectWallet(CardanoWallet wallet);

  void selectRoles(Set<AccountRole> roles);

  Future<void> prepareRegistration(SeedPhrase seedPhrase);

  Future<void> submitRegistration();
}

final class WalletLinkCubit extends Cubit<WalletLinkStateData>
    implements WalletLinkManager {
  final TransactionConfigRepository txConfigRepository;

  WalletLinkCubit({required this.txConfigRepository})
      : super(const WalletLinkStateData());

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
  Future<void> prepareRegistration(SeedPhrase seedPhrase) async {
    try {
      emit(state.copyWith(unsignedTx: const Optional(null)));

      final walletApi = await state.selectedWallet!.wallet.enable();

      final registrationBuilder = RegistrationTransactionBuilder(
        // TODO(dtscalac): inject the networkId
        transactionConfig: await txConfigRepository.fetch(NetworkId.testnet),
        networkId: NetworkId.testnet,
        seedPhrase: seedPhrase,
        roles: state.selectedRoles ?? state.defaultRoles,
        changeAddress: await walletApi.getChangeAddress(),
        rewardAddresses: await walletApi.getRewardAddresses(),
        utxos: await walletApi.getUtxos(
          amount: Balance(
            coin: CardanoWalletDetails.minAdaForRegistration,
          ),
        ),
      );

      final tx = await registrationBuilder.build();
      emit(state.copyWith(unsignedTx: Optional(Success(tx))));
    } on Exception catch (error, stackTrace) {
      _logger.severe('prepareRegistration', error, stackTrace);
      emit(state.copyWith(unsignedTx: Optional(Failure(error))));
    }
  }

  @override
  Future<void> submitRegistration() async {
    try {
      final walletApi = await state.selectedWallet!.wallet.enable();
      final unsignedTx = state.unsignedTx!.success;
      final witnessSet = await walletApi.signTx(transaction: unsignedTx);

      final signedTx = Transaction(
        body: unsignedTx.body,
        isValid: true,
        witnessSet: witnessSet,
        auxiliaryData: unsignedTx.auxiliaryData,
      );

      await walletApi.submitTx(transaction: signedTx);
    } on Exception catch (error, stackTrace) {
      _logger.severe('submitRegistration', error, stackTrace);
      emit(state.copyWith(unsignedTx: Optional(Failure(error))));
    }
  }
}
