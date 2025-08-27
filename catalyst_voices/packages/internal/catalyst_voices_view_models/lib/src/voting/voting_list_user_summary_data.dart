import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingListUserSummaryData extends Equatable {
  final int amount;
  final VotingPowerStatus? status;

  const VotingListUserSummaryData({
    this.amount = 0,
    this.status,
  });

  @override
  List<Object?> get props => [
    amount,
    status,
  ];
}
