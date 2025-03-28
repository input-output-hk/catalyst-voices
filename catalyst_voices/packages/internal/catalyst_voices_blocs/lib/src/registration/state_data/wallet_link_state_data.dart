import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkStateData extends Equatable {
  final Result<List<WalletMetadata>, Exception>? wallets;
  final WalletInfo? selectedWallet;
  final bool hasEnoughBalance;
  final WalletConnectionData? walletConnection;
  final WalletSummaryData? walletSummary;
  final List<RegistrationRole> roles;

  const WalletLinkStateData({
    this.wallets,
    this.selectedWallet,
    this.hasEnoughBalance = false,
    this.walletConnection,
    this.walletSummary,
    this.roles = const [],
  });

  factory WalletLinkStateData.initial() {
    final roles = AccountRole.values
        .where((element) => !element.isHidden)
        .map(
          (e) => RegistrationRole(
            type: e,
            isSelected: e.isDefault,
            isLocked: e.isDefault,
          ),
        )
        .toList();

    return WalletLinkStateData(roles: roles);
  }

  /// Returns the minimum required ADA in user balance to register.
  Coin get minAdaForRegistration => CardanoWalletDetails.minAdaForRegistration;

  @override
  List<Object?> get props => [
        wallets,
        selectedWallet,
        hasEnoughBalance,
        walletConnection,
        walletSummary,
        roles,
      ];

  Set<AccountRole> get selectedRoleTypes {
    return roles.where((role) => role.isSelected).map((e) => e.type).toSet();
  }

  WalletLinkStateData copyWith({
    Optional<Result<List<WalletMetadata>, Exception>>? wallets,
    Optional<WalletInfo>? selectedWallet,
    bool? hasEnoughBalance,
    Optional<WalletConnectionData>? walletConnection,
    Optional<WalletSummaryData>? walletSummary,
    List<RegistrationRole>? roles,
  }) {
    return WalletLinkStateData(
      wallets: wallets.dataOr(this.wallets),
      selectedWallet: selectedWallet.dataOr(this.selectedWallet),
      hasEnoughBalance: hasEnoughBalance ?? this.hasEnoughBalance,
      walletConnection: walletConnection.dataOr(this.walletConnection),
      walletSummary: walletSummary.dataOr(this.walletSummary),
      roles: roles ?? this.roles,
    );
  }
}
