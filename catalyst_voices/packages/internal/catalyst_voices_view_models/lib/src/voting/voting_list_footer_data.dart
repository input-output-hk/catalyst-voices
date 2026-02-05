import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingListFooterData extends Equatable {
  final bool canCastVotes;
  final bool showPendingVotesDisclaimer;
  final bool isRepresentative;
  final DateTime? lastCastedVoteAt;
  final VotingListCastingStep castingStep;

  const VotingListFooterData({
    this.canCastVotes = false,
    this.showPendingVotesDisclaimer = false,
    this.isRepresentative = false,
    this.lastCastedVoteAt,
    this.castingStep = const PreCastVotesStep(),
  });

  @override
  List<Object?> get props => [
    canCastVotes,
    showPendingVotesDisclaimer,
    isRepresentative,
    lastCastedVoteAt,
    castingStep,
  ];

  VotingListFooterData copyWith({
    bool? canCastVotes,
    bool? showPendingVotesDisclaimer,
    bool? isRepresentative,
    Optional<DateTime>? lastCastedVoteAt,
    VotingListCastingStep? castingStep,
  }) {
    return VotingListFooterData(
      canCastVotes: canCastVotes ?? this.canCastVotes,
      showPendingVotesDisclaimer: showPendingVotesDisclaimer ?? this.showPendingVotesDisclaimer,
      isRepresentative: isRepresentative ?? this.isRepresentative,
      lastCastedVoteAt: lastCastedVoteAt.dataOr(this.lastCastedVoteAt),
      castingStep: castingStep ?? this.castingStep,
    );
  }
}
