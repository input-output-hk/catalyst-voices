import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class RegistrationStateData extends Equatable {
  final Result<bool, LocalizedException>? canSubmitTx;
  final String? transactionFee;
  final bool isSubmittingTx;
  final Result<Account, LocalizedException>? account;

  const RegistrationStateData({
    this.canSubmitTx,
    this.transactionFee,
    this.isSubmittingTx = false,
    this.account,
  });

  RegistrationStateData copyWith({
    Optional<Result<bool, LocalizedException>>? canSubmitTx,
    Optional<String>? transactionFee,
    bool? isSubmittingTx,
    Optional<Result<Account, LocalizedException>>? account,
  }) {
    return RegistrationStateData(
      canSubmitTx: canSubmitTx.dataOr(this.canSubmitTx),
      transactionFee: transactionFee.dataOr(this.transactionFee),
      isSubmittingTx: isSubmittingTx ?? this.isSubmittingTx,
      account: account.dataOr(this.account),
    );
  }

  @override
  List<Object?> get props => [
        canSubmitTx,
        transactionFee,
        isSubmittingTx,
        account,
      ];
}
