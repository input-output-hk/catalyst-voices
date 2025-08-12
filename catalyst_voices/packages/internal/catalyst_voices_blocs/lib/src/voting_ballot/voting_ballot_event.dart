import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CancelCastingVotesEvent extends VotingBallotEvent {
  const CancelCastingVotesEvent();

  @override
  List<Object?> get props => [];
}

final class CastVotesEvent extends VotingBallotEvent {
  const CastVotesEvent();

  @override
  List<Object?> get props => [];
}

final class CheckPasswordEvent extends VotingBallotEvent {
  final LockFactor factor;

  const CheckPasswordEvent(this.factor);

  @override
  List<Object?> get props => [factor];
}

final class ConfirmCastingVotesEvent extends VotingBallotEvent {
  const ConfirmCastingVotesEvent();

  @override
  List<Object?> get props => [];
}

final class RemoveVoteEvent extends VotingBallotEvent {
  final DocumentRef proposal;

  const RemoveVoteEvent({
    required this.proposal,
  });

  @override
  List<Object?> get props => [proposal];
}

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

final class UpdateVoteEvent extends VotingBallotEvent {
  final DocumentRef proposal;
  final VoteType type;

  const UpdateVoteEvent({
    required this.proposal,
    required this.type,
  });

  @override
  List<Object?> get props => [proposal, type];
}

final class UpdateVoteTiles extends VotingBallotEvent {
  final List<VotingListTileData> tiles;

  const UpdateVoteTiles(this.tiles);

  @override
  List<Object?> get props => [tiles];
}

final class UpdateVotingPhaseProgressEvent extends VotingBallotEvent {
  final VotingPhaseProgressDetailsViewModel? votingPhase;

  const UpdateVotingPhaseProgressEvent({
    this.votingPhase,
  });

  @override
  List<Object?> get props => [votingPhase];
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
