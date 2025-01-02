import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final WorkspaceTabType tab;
  final bool isLoading;
  final int draftProposalCount;
  final int finalProposalCount;
  final String searchQuery;
  final List<WorkspaceProposalListItem> proposals;
  final LocalizedException? error;

  const WorkspaceState({
    this.tab = WorkspaceTabType.draftProposal,
    this.isLoading = false,
    this.draftProposalCount = 0,
    this.finalProposalCount = 0,
    this.searchQuery = '',
    this.proposals = const [],
    this.error,
  });

  bool get showProposals => !isLoading && proposals.isNotEmpty && error == null;

  bool get showEmptyState => !isLoading && proposals.isEmpty && error == null;

  bool get showError => !isLoading && error != null;

  WorkspaceState copyWith({
    WorkspaceTabType? tab,
    bool? isLoading,
    int? draftProposalCount,
    int? finalProposalCount,
    String? searchQuery,
    List<WorkspaceProposalListItem>? proposals,
    Optional<LocalizedException>? error,
  }) {
    return WorkspaceState(
      tab: tab ?? this.tab,
      isLoading: isLoading ?? this.isLoading,
      draftProposalCount: draftProposalCount ?? this.draftProposalCount,
      finalProposalCount: finalProposalCount ?? this.finalProposalCount,
      searchQuery: searchQuery ?? this.searchQuery,
      proposals: proposals ?? this.proposals,
      error: error.dataOr(this.error),
    );
  }

  @override
  List<Object?> get props => [
        tab,
        isLoading,
        draftProposalCount,
        finalProposalCount,
        searchQuery,
        proposals,
        error,
      ];
}
