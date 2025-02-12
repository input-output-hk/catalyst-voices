import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class ProposalSearchResult extends Equatable {
  final int finalProposalCount;
  final int draftProposalCount;
  final int favoriteProposalCount;
  final int myProposalCount;
  final List<Proposal> proposals;

  const ProposalSearchResult({
    this.finalProposalCount = 0,
    this.draftProposalCount = 0,
    this.favoriteProposalCount = 0,
    this.myProposalCount = 0,
    this.proposals = const [],
  });

  ProposalSearchResult copyWith({
    int? finalProposalCount,
    int? draftProposalCount,
    int? favoriteProposalCount,
    int? myProposalCount,
    List<Proposal>? proposals,
  }) {
    return ProposalSearchResult(
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
