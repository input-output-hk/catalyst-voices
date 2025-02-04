import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
sealed class ProposalsState extends Equatable {
  final List<ProposalViewModel> proposals;
  final int pageNumber;
  final bool reachMax;

  const ProposalsState({
    this.proposals = const [],
    this.pageNumber = 1,
    this.reachMax = false,
  });

  @override
  List<Object?> get props => [proposals];
}

/// The proposals are loading.
final class LoadingProposalsState extends ProposalsState {
  const LoadingProposalsState({
    super.proposals,
    super.pageNumber,
    super.reachMax,
  });

  LoadingProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? pageNumber,
    bool? reachMax,
  }) {
    return LoadingProposalsState(
      proposals: proposals ?? this.proposals,
      pageNumber: pageNumber ?? this.pageNumber,
      reachMax: reachMax ?? this.reachMax,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}

/// The loaded proposals.
final class LoadedProposalsState extends ProposalsState {
  const LoadedProposalsState({
    super.proposals,
    super.pageNumber,
    super.reachMax,
  });

  LoadedProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? pageNumber,
    bool? reachMax,
  }) {
    return LoadedProposalsState(
      proposals: proposals ?? this.proposals,
      pageNumber: pageNumber ?? this.pageNumber,
      reachMax: reachMax ?? this.reachMax,
    );
  }

  @override
  List<Object?> get props => [...super.proposals];
}

final class ErrorProposalsState extends ProposalsState {
  final LocalizedException error;

  const ErrorProposalsState({
    super.proposals,
    super.pageNumber,
    super.reachMax,
    required this.error,
  });

  ErrorProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? pageNumber,
    bool? reachMax,
    LocalizedException? error,
  }) {
    return ErrorProposalsState(
      proposals: proposals ?? this.proposals,
      pageNumber: pageNumber ?? this.pageNumber,
      reachMax: reachMax ?? this.reachMax,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [...super.props, error];
}
