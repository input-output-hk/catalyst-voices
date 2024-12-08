import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
sealed class ProposalsState extends Equatable {
  const ProposalsState();
}

/// The proposals are loading.
final class LoadingProposalsState extends ProposalsState {
  const LoadingProposalsState();

  @override
  List<Object?> get props => [];
}

/// The loaded proposals.
final class LoadedProposalsState extends ProposalsState {
  final List<ProposalViewModel> proposals;
  final List<ProposalViewModel> favoriteProposals;

  const LoadedProposalsState({
    this.proposals = const [],
    this.favoriteProposals = const [],
  });

  @override
  List<Object?> get props => [proposals, favoriteProposals];
}
