import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

// TODO(damian-molinski): refactor have less logic and no raw models.
final class RegistrationStateData extends Equatable {
  final Result<Transaction, LocalizedException>? registrationTx;
  final Result<Account, LocalizedException>? account;
  final bool isSubmittingTx;

  const RegistrationStateData({
    this.registrationTx,
    this.account,
    this.isSubmittingTx = false,
  });

  /// Returns the registration transaction fee.
  Coin? get transactionFee {
    final result = registrationTx;
    if (result == null) return null;

    final tx = result.isSuccess ? result.success : null;
    return tx?.body.fee;
  }

  /// Whether the button to submit the transaction should be enabled.
  bool get canSubmitTx {
    return (registrationTx?.isSuccess ?? false) && (!isSubmittingTx);
  }

  RegistrationStateData copyWith({
    Optional<Result<Transaction, LocalizedException>>? registrationTx,
    Optional<Result<Account, LocalizedException>>? account,
    bool? isSubmittingTx,
  }) {
    return RegistrationStateData(
      registrationTx: registrationTx.dataOr(this.registrationTx),
      isSubmittingTx: isSubmittingTx ?? this.isSubmittingTx,
      account: account.dataOr(this.account),
    );
  }

  @override
  List<Object?> get props => [
        registrationTx,
        isSubmittingTx,
        account,
      ];
}
