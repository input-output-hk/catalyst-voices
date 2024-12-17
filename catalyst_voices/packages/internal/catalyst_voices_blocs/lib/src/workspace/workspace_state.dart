import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final WorkspaceTabType tab;
  final bool isLoading;
  final int draftProposalCount;
  final int finalProposalCount;
  final String searchQuery;

  const WorkspaceState({
    this.tab = WorkspaceTabType.draftProposal,
    this.isLoading = false,
    this.draftProposalCount = 0,
    this.finalProposalCount = 0,
    this.searchQuery = '',
  });

  WorkspaceState copyWith({
    WorkspaceTabType? tab,
    bool? isLoading,
    int? draftProposalCount,
    int? finalProposalCount,
    String? searchQuery,
  }) {
    return WorkspaceState(
      tab: tab ?? this.tab,
      isLoading: isLoading ?? this.isLoading,
      draftProposalCount: draftProposalCount ?? this.draftProposalCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        tab,
        isLoading,
        draftProposalCount,
        finalProposalCount,
        searchQuery,
      ];
}
