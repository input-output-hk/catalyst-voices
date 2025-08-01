import 'dart:async';

import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:result_type/result_type.dart';

final _logger = Logger('WalletLinkCubit');

/// Manages the wallet linking process.
///
/// Allows to link a wallet to the account.
final class WalletLinkCubit extends Cubit<WalletLinkStateData>
    with BlocErrorEmitterMixin
    implements WalletLinkManager {
  final RegistrationService registrationService;
  final BlockchainConfig blockchainConfig;

  final _wallets = <CardanoWallet>[];
  CardanoWallet? _selectedWallet;

  WalletLinkCubit({
    required this.registrationService,
    required this.blockchainConfig,
  }) : super(WalletLinkStateData.initial());

  Set<AccountRole> get roles =>
      state.roles.where((element) => element.isSelected).map((e) => e.type).toSet();

  CardanoWallet? get selectedWallet => _selectedWallet;

  @override
  Future<void> refreshWallets() async {
    try {
      _wallets.clear();
      emit(state.copyWith(wallets: const Optional.empty()));

      final wallets = await registrationService.getCardanoWallets().withMinimumDelay();

      _wallets
        ..clear()
        ..addAll(wallets);

      final walletsMetaList = wallets.map(WalletMetadata.fromCardanoWallet).toList();

      emit(state.copyWith(wallets: Optional(Success(walletsMetaList))));
    } on Exception catch (error, stackTrace) {
      _logger.severe('refreshWallets', error, stackTrace);

      _wallets.clear();

      emit(state.copyWith(wallets: Optional(Failure(error))));
    }
  }

  @override
  void selectRoles(Set<AccountRole> roles) {
    final updatedRoles = state.roles.map(
      (role) {
        return role.copyWith(
          isSelected: role.type.isDefault || roles.contains(role.type),
        );
      },
    ).toList();

    emit(state.copyWith(roles: updatedRoles));
  }

  @override
  Future<bool> selectWallet(WalletMetadata meta) async {
    try {
      final wallet = _wallets.firstWhereOrNull((wallet) => wallet.name.equalsIgnoreCase(meta.name));

      if (wallet == null) {
        throw const LocalizedRegistrationWalletNotFoundException();
      }

      _selectedWallet = wallet;

      final walletInfo = await registrationService.getCardanoWalletInfo(wallet);

      final walletConnection = WalletConnectionData(
        name: walletInfo.metadata.name,
        icon: walletInfo.metadata.icon,
      );
      final walletSummary = WalletSummaryData(
        walletName: walletInfo.metadata.name,
        balance: CryptocurrencyFormatter.formatAmount(walletInfo.balance),
        address: WalletAddressFormatter.formatShort(walletInfo.address),
        clipboardAddress: walletInfo.address.toBech32(),
        showLowBalance: walletInfo.balance < CardanoWalletDetails.minAdaForRegistration,
        showExpectedNetworkId:
            blockchainConfig.networkId != walletInfo.networkId ? blockchainConfig.networkId : null,
      );

      final newState = state.copyWith(
        selectedWallet: Optional(walletInfo),
        hasEnoughBalance: walletInfo.balance >= CardanoWalletDetails.minAdaForRegistration,
        isNetworkIdMatching: walletInfo.networkId == blockchainConfig.networkId,
        walletConnection: Optional(walletConnection),
        walletSummary: Optional(walletSummary),
      );

      emit(newState);

      return true;
    } on WalletApiException catch (error, stackTrace) {
      _logger.log(
        error.code != WalletApiErrorCode.refused ? Level.SEVERE : Level.FINER,
        'select wallet',
        error,
        stackTrace,
      );

      _selectedWallet = null;

      emit(
        state.copyWith(
          selectedWallet: const Optional.empty(),
          walletConnection: const Optional.empty(),
          walletSummary: const Optional.empty(),
        ),
      );

      emitError(LocalizedWalletLinkException(code: error.code));

      return false;
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

  void setAccountRoles(Set<AccountRole> roles) {
    final updatedRoles = state.roles.map(
      (role) {
        final isAccountRole = roles.contains(role.type);
        final isLocked = role.type.isDefault || isAccountRole;

        return role.copyWith(
          isLocked: isLocked,
          isSelected: isAccountRole ? true : null,
        );
      },
    ).toList();

    emit(state.copyWith(roles: updatedRoles, accountRoles: roles));
  }
}

abstract interface class WalletLinkManager {
  Future<void> refreshWallets();

  void selectRoles(Set<AccountRole> roles);

  Future<bool> selectWallet(WalletMetadata meta);
}
