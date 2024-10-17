import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  Future<bool> selectWallet(WalletMetadata meta);

  void selectRoles(Set<AccountRole> roles);
}

final class WalletLinkCubit extends Cubit<WalletLinkStateData>
    with BlocErrorEmitterMixin
    implements WalletLinkManager {
  final RegistrationService registrationService;

  final _wallets = <CardanoWallet>[];
  CardanoWallet? _selectedWallet;

  WalletLinkCubit({required this.registrationService})
      : super(const WalletLinkStateData());

  CardanoWallet? get selectedWallet => _selectedWallet;

  @override
  Future<void> refreshWallets() async {
    try {
      _wallets.clear();
      emit(state.copyWith(wallets: const Optional.empty()));

      final wallets =
          await registrationService.getCardanoWallets();

      _wallets
        ..clear()
        ..addAll(wallets);

      final walletsMetaList =
          wallets.map(WalletMetadata.fromCardanoWallet).toList();

      emit(state.copyWith(wallets: Optional(Success(walletsMetaList))));
    } on Exception catch (error, stackTrace) {
      _logger.severe('refreshWallets', error, stackTrace);

      _wallets.clear();

      emit(state.copyWith(wallets: Optional(Failure(error))));
    }
  }

  @override
  Future<bool> selectWallet(WalletMetadata meta) async {
    try {
      final wallet =
          _wallets.firstWhereOrNull((wallet) => wallet.name == meta.name);

      if (wallet == null) {
        throw const LocalizedRegistrationWalletNotFoundException();
      }

      _selectedWallet = wallet;

      final walletHeader =
          await registrationService.getCardanoWalletDetails(wallet);

      final walletConnection = WalletConnectionData(
        name: walletHeader.metadata.name,
        icon: walletHeader.metadata.icon,
        isConnected: true,
      );
      final walletSummary = WalletSummaryData(
        balance: CryptocurrencyFormatter.formatAmount(walletHeader.balance),
        address: WalletAddressFormatter.formatShort(walletHeader.address),
        clipboardAddress: walletHeader.address.toBech32(),
        showLowBalance:
            walletHeader.balance < CardanoWalletDetails.minAdaForRegistration,
      );

      final newState = state.copyWith(
        selectedWallet: Optional(walletHeader),
        hasEnoughBalance:
            walletHeader.balance >= CardanoWalletDetails.minAdaForRegistration,
        walletConnection: Optional(walletConnection),
        walletSummary: Optional(walletSummary),
      );

      emit(newState);

      return true;
    } catch (error, stackTrace) {
      _logger.severe('selectWallet', error, stackTrace);

      _selectedWallet = null;

      emit(
        state.copyWith(
          selectedWallet: const Optional.empty(),
          walletConnection: const Optional.empty(),
          walletSummary: const Optional.empty(),
        ),
      );

      emitError(error);

      return false;
    }
  }

  @override
  void selectRoles(Set<AccountRole> roles) {
    emit(state.copyWith(selectedRoles: Optional(roles)));
  }
}
