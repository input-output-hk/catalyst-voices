import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotState extends Equatable {
  final VotingListCampaignPhaseData votingProgress;
  final VotingListUserSummaryData userSummary;
  final List<VotingListTileData> tiles;
  final VotingListFooterData footer;

  const VotingBallotState({
    this.votingProgress = const VotingListCampaignPhaseData(),
    this.userSummary = const VotingListUserSummaryData(),
    this.tiles = const [],
    this.footer = const VotingListFooterData(),
  });

  @override
  List<Object?> get props => [
        votingProgress,
        userSummary,
        tiles,
        footer,
      ];

  VotingBallotState copyWith({
    VotingListCampaignPhaseData? votingProgress,
    VotingListUserSummaryData? userSummary,
    List<VotingListTileData>? tiles,
    VotingListFooterData? footer,
  }) {
    return VotingBallotState(
      votingProgress: votingProgress ?? this.votingProgress,
      userSummary: userSummary ?? this.userSummary,
      tiles: tiles ?? this.tiles,
      footer: footer ?? this.footer,
    );
  }
}
