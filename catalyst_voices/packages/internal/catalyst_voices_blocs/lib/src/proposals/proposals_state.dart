import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final int pageKey;
  final ProposalSearchViewModel proposals;
  final bool isLoading;
  final LocalizedException? error;

  const ProposalsState({
    this.pageKey = 0,
    this.proposals = const ProposalSearchViewModel(),
    this.isLoading = false,
    this.error,
  });

  ProposalsState copyWith({
    int? pageKey,
    ProposalSearchViewModel? proposals,
    bool? isLoading,
    Optional<LocalizedException>? error,
  }) {
    return ProposalsState(
      pageKey: pageKey ?? this.pageKey,
      proposals: proposals ?? this.proposals,
      isLoading: isLoading ?? this.isLoading,
      error: error.dataOr(this.error),
    );
  }

  @override
  List<Object?> get props => [
        proposals,
        pageKey,
      ];
}
