import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class RegistrationStateData extends Equatable {
  final Result<bool, LocalizedException>? canSubmitTx;
  final String? transactionFee;
  final bool isSubmittingTx;

  const RegistrationStateData({
    this.canSubmitTx,
    this.transactionFee,
    this.isSubmittingTx = false,
  });

  @override
  List<Object?> get props => [
        canSubmitTx,
        transactionFee,
        isSubmittingTx,
      ];

  RegistrationStateData copyWith({
    Optional<Result<bool, LocalizedException>>? canSubmitTx,
    Optional<String>? transactionFee,
    bool? isSubmittingTx,
  }) {
    return RegistrationStateData(
      canSubmitTx: canSubmitTx.dataOr(this.canSubmitTx),
      transactionFee: transactionFee.dataOr(this.transactionFee),
      isSubmittingTx: isSubmittingTx ?? this.isSubmittingTx,
    );
  }
}
