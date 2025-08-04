import 'package:equatable/equatable.dart';

final class VotingListFooterData extends Equatable {
  final bool canCastVotes;
  final bool showPendingVotesDisclaimer;
  final DateTime? lastCastedVoteAt;

  const VotingListFooterData({
    this.canCastVotes = false,
    this.showPendingVotesDisclaimer = false,
    this.lastCastedVoteAt,
  });

  @override
  List<Object?> get props => [
        canCastVotes,
        showPendingVotesDisclaimer,
        lastCastedVoteAt,
      ];
}
