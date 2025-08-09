import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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

  VotingListFooterData copyWith({
    bool? canCastVotes,
    bool? showPendingVotesDisclaimer,
    Optional<DateTime>? lastCastedVoteAt,
  }) {
    return VotingListFooterData(
      canCastVotes: canCastVotes ?? this.canCastVotes,
      showPendingVotesDisclaimer: showPendingVotesDisclaimer ?? this.showPendingVotesDisclaimer,
      lastCastedVoteAt: lastCastedVoteAt.dataOr(this.lastCastedVoteAt),
    );
  }
}
