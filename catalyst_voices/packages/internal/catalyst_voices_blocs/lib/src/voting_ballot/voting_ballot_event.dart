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

final class TimerTickEvent extends VotingBallotEvent {
  const TimerTickEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateFromBallotBuilderEvent extends VotingBallotEvent {
  final bool showPendingVotesDisclaimer;
  final bool canCastVotes;
  final int proposalsCount;

  const UpdateFromBallotBuilderEvent({
    required this.showPendingVotesDisclaimer,
    required this.canCastVotes,
    required this.proposalsCount,
  });

  @override
  List<Object?> get props => [
    showPendingVotesDisclaimer,
    canCastVotes,
    proposalsCount,
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

final class UpdateVotingRoleEvent extends VotingBallotEvent {
  final AccountVotingRole? data;

  const UpdateVotingRoleEvent(this.data);

  @override
  List<Object?> get props => [data];
}

sealed class VotingBallotEvent extends Equatable {
  const VotingBallotEvent();
}
