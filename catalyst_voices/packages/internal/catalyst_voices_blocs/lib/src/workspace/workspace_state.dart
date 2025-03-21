import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class WorkspaceState extends Equatable {
  final bool isLoading;
  final LocalizedException? error;
  final List<Proposal> userProposals;

  const WorkspaceState({
    this.isLoading = false,
    this.error,
    this.userProposals = const [],
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
        userProposals,
      ];

  bool get showError => error != null && !isLoading;
  bool get showLoading => isLoading;
  bool get showProposals => error == null && !isLoading;

  WorkspaceState copyWith({
    WorkspaceTabType? tab,
    bool? isLoading,
    int? draftProposalCount,
    int? finalProposalCount,
    String? searchQuery,
    List<WorkspaceProposalListItem>? proposals,
    Optional<LocalizedException>? error,
    List<Proposal>? userProposals,
  }) {
    return WorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
      userProposals: userProposals ?? this.userProposals,
    );
  }
}
