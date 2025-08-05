import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class UpdateFooterFromBallotBuilderEvent extends VotingBallotEvent {
  final bool canCastVotes;
  final bool showPendingVotesDisclaimer;

  const UpdateFooterFromBallotBuilderEvent({
    required this.canCastVotes,
    required this.showPendingVotesDisclaimer,
  });

  @override
  List<Object?> get props => [
        canCastVotes,
        showPendingVotesDisclaimer,
      ];
}

final class UpdateFundNumberEvent extends VotingBallotEvent {
  final int? number;

  const UpdateFundNumberEvent(this.number);

  @override
  List<Object?> get props => [number];
}

final class UpdateLastCastedVoteEvent extends VotingBallotEvent {
  final DateTime? votedAt;

  const UpdateLastCastedVoteEvent(this.votedAt);

  @override
  List<Object?> get props => [votedAt];
}

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
