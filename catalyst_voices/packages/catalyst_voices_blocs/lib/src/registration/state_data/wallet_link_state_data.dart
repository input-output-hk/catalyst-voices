import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class WalletLinkStateData extends Equatable {
  final Result<List<CardanoWallet>, Exception>? wallets;
  final CardanoWalletDetails? selectedWallet;
  final Set<AccountRole>? selectedRoles;
  final Result<Transaction, Exception>? unsignedTx;
  final Result<Transaction, Exception>? submittedTx;
  final bool isSubmittingTx;

  const WalletLinkStateData({
    this.wallets,
    this.selectedWallet,
    this.selectedRoles,
    this.unsignedTx,
    this.submittedTx,
    this.isSubmittingTx = false,
  });

  /// Returns the minimum required ADA in user balance to register.
  Coin get minAdaForRegistration => CardanoWalletDetails.minAdaForRegistration;

  /// Returns the default roles every account will have.
  Set<AccountRole> get defaultRoles => {AccountRole.voter};

  /// Returns the registration transaction fee.
  Coin? get transactionFee {
    final result = unsignedTx;
    if (result == null) return null;

    final tx = result.isSuccess ? result.success : null;
    return tx?.body.fee;
  }

  WalletLinkStateData copyWith({
    Optional<Result<List<CardanoWallet>, Exception>>? wallets,
    Optional<CardanoWalletDetails>? selectedWallet,
    Optional<Set<AccountRole>>? selectedRoles,
    Optional<Result<Transaction, Exception>>? unsignedTx,
    Optional<Result<Transaction, Exception>>? submittedTx,
    bool? isSubmittingTx,
  }) {
    return WalletLinkStateData(
      wallets: wallets.dataOr(this.wallets),
      selectedWallet: selectedWallet.dataOr(this.selectedWallet),
      selectedRoles: selectedRoles.dataOr(this.selectedRoles),
      unsignedTx: unsignedTx.dataOr(this.unsignedTx),
      submittedTx: submittedTx.dataOr(this.submittedTx),
      isSubmittingTx: isSubmittingTx ?? this.isSubmittingTx,
    );
  }

  @override
  List<Object?> get props => [
        wallets,
        selectedWallet,
        selectedRoles,
        unsignedTx,
        submittedTx,
        isSubmittingTx,
      ];
}
