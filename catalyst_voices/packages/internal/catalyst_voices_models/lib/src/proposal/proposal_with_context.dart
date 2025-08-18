import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalUserContext extends Equatable {
  final bool isFavorite;
  final Vote? lastCastedVote;

  const ProposalUserContext({
    this.isFavorite = false,
    this.lastCastedVote,
  });

  @override
  List<Object?> get props => [
    isFavorite,
    lastCastedVote,
  ];

  ProposalUserContext copyWith({
    bool? isFavorite,
    Optional<Vote>? lastCastedVote,
  }) {
    return ProposalUserContext(
      isFavorite: isFavorite ?? this.isFavorite,
      lastCastedVote: lastCastedVote.dataOr(this.lastCastedVote),
    );
  }
}

final class ProposalWithContext extends Equatable {
  final Proposal proposal;
  final CampaignCategory category;
  final ProposalUserContext user;

  const ProposalWithContext({
    required this.proposal,
    required this.category,
    required this.user,
  });

  @override
  List<Object?> get props => [
    proposal,
    category,
    user,
  ];

  ProposalWithContext copyWith({
    Proposal? proposal,
    CampaignCategory? category,
    ProposalUserContext? user,
  }) {
    return ProposalWithContext(
      proposal: proposal ?? this.proposal,
      category: category ?? this.category,
      user: user ?? this.user,
    );
  }
}
