import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  Future<bool> selectWallet(CardanoWallet wallet);

  void selectRoles(Set<AccountRole> roles);
}

final class WalletLinkCubit extends Cubit<WalletLinkStateData>
    with BlocErrorEmitterMixin
    implements WalletLinkManager {
  final RegistrationService registrationService;

  WalletLinkCubit({required this.registrationService})
      : super(const WalletLinkStateData());

  @override
  Future<void> refreshWallets() async {
    try {
      emit(state.copyWith(wallets: const Optional.empty()));

      final wallets =
          await registrationService.getCardanoWallets().withMinimumDelay();

      emit(state.copyWith(wallets: Optional(Success(wallets))));
    } on Exception catch (error, stackTrace) {
      _logger.severe('refreshWallets', error, stackTrace);
      emit(state.copyWith(wallets: Optional(Failure(error))));
    }
  }

  @override
  Future<bool> selectWallet(CardanoWallet wallet) async {
    try {
      final walletDetails =
          await registrationService.getCardanoWalletDetails(wallet);

      final walletConnection = WalletConnectionData(
        name: wallet.name,
        icon: wallet.icon,
        isConnected: true,
      );
      final walletSummary = WalletSummaryData(
        balance: CryptocurrencyFormatter.formatAmount(walletDetails.balance),
        address: WalletAddressFormatter.formatShort(walletDetails.address),
        clipboardAddress: walletDetails.address.toBech32(),
        showLowBalance:
            walletDetails.balance < CardanoWalletDetails.minAdaForRegistration,
      );

      final newState = state.copyWith(
        selectedWallet: Optional(walletDetails),
        walletConnection: Optional(walletConnection),
        walletSummary: Optional(walletSummary),
      );

      emit(newState);

      return true;
    } catch (error, stackTrace) {
      _logger.severe('selectWallet', error, stackTrace);

      emit(
        state.copyWith(
          selectedWallet: const Optional.empty(),
          walletConnection: const Optional.empty(),
          walletSummary: const Optional.empty(),
        ),
      );

      return false;
    }
  }

  @override
  void selectRoles(Set<AccountRole> roles) {
    emit(state.copyWith(selectedRoles: Optional(roles)));
  }
}
