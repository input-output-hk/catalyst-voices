import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotState extends Equatable {
  final VotingListCampaignPhaseData votingProgress;
  final VotingListUserSummaryData userSummary;
  final List<VotingListTileData> tiles;
  final VotingListFooterData footer;
  final int votesCount;
  final VotingBallotBuilderFabViewModel fab;

  const VotingBallotState({
    this.votingProgress = const VotingListCampaignPhaseData(),
    this.userSummary = const VotingListUserSummaryData(),
    this.tiles = const [],
    this.footer = const VotingListFooterData(),
    this.votesCount = 0,
    this.fab = const VotingBallotBuilderFabViewModel(),
  });

  @override
  List<Object?> get props => [
    votingProgress,
    userSummary,
    tiles,
    footer,
    votesCount,
    fab,
  ];

  VotingBallotState copyWith({
    VotingListCampaignPhaseData? votingProgress,
    VotingListUserSummaryData? userSummary,
    List<VotingListTileData>? tiles,
    VotingListFooterData? footer,
    int? votesCount,
    VotingBallotBuilderFabViewModel? fab,
  }) {
    return VotingBallotState(
      votingProgress: votingProgress ?? this.votingProgress,
      userSummary: userSummary ?? this.userSummary,
      tiles: tiles ?? this.tiles,
      footer: footer ?? this.footer,
      votesCount: votesCount ?? this.votesCount,
      fab: fab ?? this.fab,
    );
  }
}
