import 'package:equatable/equatable.dart';

final class VotingListCampaignPhaseData extends Equatable {
  final int? activeFundNumber;
  final double votingPhaseProgress;
  final Duration? votingEndsIn;

  const VotingListCampaignPhaseData({
    this.activeFundNumber,
    this.votingPhaseProgress = 0,
    this.votingEndsIn,
  }) : assert(
          votingPhaseProgress >= 0 && votingPhaseProgress <= 1,
          'votingPhaseProgress is not in 0:1 range',
        );

  @override
  List<Object?> get props => [
        activeFundNumber,
        votingPhaseProgress,
        votingEndsIn,
      ];
}
