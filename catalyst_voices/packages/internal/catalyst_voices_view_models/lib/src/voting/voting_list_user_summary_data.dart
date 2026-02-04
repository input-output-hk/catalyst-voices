import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/src/voting/voting_power_view_model.dart';
import 'package:equatable/equatable.dart';

final class VotingListUserSummaryData extends Equatable {
  final VotingPowerAmount formattedAmount;
  final VotingPowerStatus? status;
  final bool isRepresentative;
  final int delegatorsCount;
  final DateTime? updatedAt;

  const VotingListUserSummaryData({
    this.formattedAmount = const VotingPowerAmount.empty(),
    this.status,
    this.isRepresentative = false,
    this.delegatorsCount = 0,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    formattedAmount,
    status,
    isRepresentative,
    delegatorsCount,
    updatedAt,
  ];
}
