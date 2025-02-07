import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
sealed class ProposalsState extends Equatable {
  final List<ProposalViewModel> proposals;
  final int resultsNumber;

  const ProposalsState({
    this.proposals = const [],
    this.resultsNumber = 0,
  });

  ProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
  });

  @override
  List<Object?> get props => [proposals, resultsNumber];
}

/// The proposals are loading.
final class LoadingProposalsState extends ProposalsState {
  const LoadingProposalsState({
    super.proposals,
    super.resultsNumber,
  });

  @override
  LoadingProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    bool? reachMax,
  }) {
    return LoadingProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}

/// The loaded proposals.
final class LoadedProposalsState extends ProposalsState {
  const LoadedProposalsState({
    super.proposals,
    super.resultsNumber,
  });

  @override
  LoadedProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    bool? reachMax,
  }) {
    return LoadedProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
    );
  }

  @override
  List<Object?> get props => [...super.proposals];
}

final class ErrorProposalsState extends ProposalsState {
  final LocalizedException error;

  const ErrorProposalsState({
    super.proposals,
    super.resultsNumber,
    required this.error,
  });

  @override
  ErrorProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    bool? reachMax,
    LocalizedException? error,
  }) {
    return ErrorProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [...super.props, error];
}
