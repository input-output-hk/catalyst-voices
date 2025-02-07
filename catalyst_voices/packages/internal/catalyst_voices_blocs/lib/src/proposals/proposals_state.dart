import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
sealed class ProposalsState extends Equatable {
  final List<ProposalViewModel> proposals;
  final int resultsNumber;
  final int pageKey;

  const ProposalsState({
    this.proposals = const [],
    this.resultsNumber = 0,
    this.pageKey = 0,
  });

  ProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    int? pageKey,
  });

  @override
  List<Object?> get props => [
        proposals,
        resultsNumber,
        pageKey,
      ];
}

/// The proposals are loading.
final class LoadingProposalsState extends ProposalsState {
  const LoadingProposalsState({
    super.proposals,
    super.resultsNumber,
    super.pageKey,
  });

  @override
  LoadingProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    int? pageKey,
  }) {
    return LoadingProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
      pageKey: pageKey ?? this.pageKey,
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
    super.pageKey,
  });

  @override
  LoadedProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    int? pageKey,
  }) {
    return LoadedProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
      pageKey: pageKey ?? this.pageKey,
    );
  }

  @override
  List<Object?> get props => [...super.props];
}

final class ErrorProposalsState extends ProposalsState {
  final LocalizedException error;

  const ErrorProposalsState({
    super.proposals,
    super.resultsNumber,
    super.pageKey,
    required this.error,
  });

  @override
  ErrorProposalsState copyWith({
    List<ProposalViewModel>? proposals,
    int? resultsNumber,
    LocalizedException? error,
    int? pageKey,
  }) {
    return ErrorProposalsState(
      proposals: proposals ?? this.proposals,
      resultsNumber: resultsNumber ?? this.resultsNumber,
      error: error ?? this.error,
      pageKey: pageKey ?? this.pageKey,
    );
  }

  @override
  List<Object?> get props => [...super.props, error];
}
