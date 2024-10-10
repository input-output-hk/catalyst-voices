import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  Future<bool> selectWallet(CardanoWallet wallet);

  void selectRoles(Set<AccountRole> roles);
}

final class WalletLinkCubit extends Cubit<WalletLinkStateData>
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
}
