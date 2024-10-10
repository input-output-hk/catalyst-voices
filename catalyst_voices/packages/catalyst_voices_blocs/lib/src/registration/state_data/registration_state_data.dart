import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class RegistrationStateData extends Equatable {
  final Result<Transaction, LocalizedException>? unsignedTx;
  final Result<Transaction, LocalizedException>? submittedTx;
  final bool isSubmittingTx;

  const RegistrationStateData({
    this.unsignedTx,
    this.submittedTx,
    this.isSubmittingTx = false,
  });

  /// Returns the registration transaction fee.
  Coin? get transactionFee {
    final result = unsignedTx;
    if (result == null) return null;

    final tx = result.isSuccess ? result.success : null;
    return tx?.body.fee;
  }

  /// Whether the button to submit the transaction should be enabled.
  bool get canSubmitTx => (unsignedTx?.isSuccess ?? false) && (!isSubmittingTx);

  RegistrationStateData copyWith({
    Optional<Result<Transaction, LocalizedException>>? unsignedTx,
    Optional<Result<Transaction, LocalizedException>>? submittedTx,
    bool? isSubmittingTx,
  }) {
    return RegistrationStateData(
      unsignedTx: unsignedTx.dataOr(this.unsignedTx),
      submittedTx: submittedTx.dataOr(this.submittedTx),
      isSubmittingTx: isSubmittingTx ?? this.isSubmittingTx,
    );
  }

  @override
  List<Object?> get props => [
        unsignedTx,
        submittedTx,
        isSubmittingTx,
      ];
}
