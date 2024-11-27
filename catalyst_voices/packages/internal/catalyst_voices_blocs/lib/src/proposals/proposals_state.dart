import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
  final List<PendingProposal> proposals;
  final List<PendingProposal> favoriteProposals;

  const LoadedProposalsState({
    required this.proposals,
    required this.favoriteProposals,
  });

  @override
  List<Object?> get props => [proposals, favoriteProposals];
}
