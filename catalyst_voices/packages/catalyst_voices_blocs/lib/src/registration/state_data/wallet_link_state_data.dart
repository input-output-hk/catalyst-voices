import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkStateData extends Equatable {
  final Result<List<WalletMeta>, Exception>? wallets;
  final WalletHeader? selectedWallet;
  final bool hasEnoughBalance;
  final WalletConnectionData? walletConnection;
  final WalletSummaryData? walletSummary;
  final Set<AccountRole>? selectedRoles;

  const WalletLinkStateData({
    this.wallets,
    this.selectedWallet,
    this.hasEnoughBalance = false,
    this.walletConnection,
    this.walletSummary,
    this.selectedRoles,
  });

  /// Returns the minimum required ADA in user balance to register.
  Coin get minAdaForRegistration => CardanoWalletDetails.minAdaForRegistration;

  /// Returns the default roles every account will have.
  Set<AccountRole> get defaultRoles => {AccountRole.voter};

  WalletLinkStateData copyWith({
    Optional<Result<List<WalletMeta>, Exception>>? wallets,
    Optional<WalletHeader>? selectedWallet,
    bool? hasEnoughBalance,
    Optional<WalletConnectionData>? walletConnection,
    Optional<WalletSummaryData>? walletSummary,
    Optional<Set<AccountRole>>? selectedRoles,
  }) {
    return WalletLinkStateData(
      wallets: wallets.dataOr(this.wallets),
      selectedWallet: selectedWallet.dataOr(this.selectedWallet),
      hasEnoughBalance: hasEnoughBalance ?? this.hasEnoughBalance,
      walletConnection: walletConnection.dataOr(this.walletConnection),
      walletSummary: walletSummary.dataOr(this.walletSummary),
      selectedRoles: selectedRoles.dataOr(this.selectedRoles),
    );
  }

  @override
  List<Object?> get props => [
        wallets,
        selectedWallet,
        hasEnoughBalance,
        walletConnection,
        walletSummary,
        selectedRoles,
      ];
}
