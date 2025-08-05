import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UpdateVotingPhaseProgressEvent extends VotingBallotEvent {
  final double votingPhaseProgress;
  final Duration? votingEndsIn;

  const UpdateVotingPhaseProgressEvent({
    this.votingPhaseProgress = 0,
    this.votingEndsIn,
  });

  @override
  List<Object?> get props => [votingPhaseProgress, votingEndsIn];
}

final class UpdateVotingPowerEvent extends VotingBallotEvent {
  final VotingPower? data;

  const UpdateVotingPowerEvent(this.data);

  @override
  List<Object?> get props => [data];
}

sealed class VotingBallotEvent extends Equatable {
  const VotingBallotEvent();
}
