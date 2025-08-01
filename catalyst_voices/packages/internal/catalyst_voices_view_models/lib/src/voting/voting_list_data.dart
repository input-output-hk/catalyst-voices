import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingListData extends Equatable {
  final VotingListCampaignPhaseData votingProgress;
  final VotingListUserSummaryData userSummary;
  final List<VotingListTileData> tiles;
  final VotingListFooterData footer;

  const VotingListData({
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
}
