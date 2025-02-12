import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

class ProposalSearchViewModel extends Equatable {
  final int finalProposalCount;
  final int draftProposalCount;
  final int favoriteProposalCount;
  final int myProposalCount;
  final List<ProposalViewModel> proposals;

  const ProposalSearchViewModel({
    this.finalProposalCount = 0,
    this.draftProposalCount = 0,
    this.favoriteProposalCount = 0,
    this.myProposalCount = 0,
    this.proposals = const [],
  });

  factory ProposalSearchViewModel.fromModel(
    ProposalSearchResult model,
    String campaignName,
    CampaignStage campaignStage,
  ) {
    return ProposalSearchViewModel(
      finalProposalCount: model.finalProposalCount,
      draftProposalCount: model.draftProposalCount,
      favoriteProposalCount: model.favoriteProposalCount,
      myProposalCount: model.myProposalCount,
      proposals: model.proposals
          .map(
            (e) => ProposalViewModel.fromProposalAtStage(
              proposal: e,
              campaignName: campaignName,
              campaignStage: campaignStage,
            ),
          )
          .toList(),
    );
  }

  ProposalSearchViewModel copyWith({
    int? finalProposalCount,
    int? draftProposalCount,
    int? favoriteProposalCount,
    int? myProposalCount,
    List<ProposalViewModel>? proposals,
  }) {
    return ProposalSearchViewModel(
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      draftProposalCount: draftProposalCount ?? this.draftProposalCount,
      favoriteProposalCount:
          favoriteProposalCount ?? this.favoriteProposalCount,
      myProposalCount: myProposalCount ?? this.myProposalCount,
      proposals: proposals ?? this.proposals,
    );
  }

  int get totalProposalCount =>
      finalProposalCount +
      draftProposalCount +
      favoriteProposalCount +
      myProposalCount;

  @override
  List<Object?> get props => [
        finalProposalCount,
        draftProposalCount,
        favoriteProposalCount,
        myProposalCount,
        proposals,
      ];
}
