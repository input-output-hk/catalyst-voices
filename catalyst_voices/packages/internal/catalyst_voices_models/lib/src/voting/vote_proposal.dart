import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VoteProposal extends Equatable {
  final DocumentRef ref;
  final VoteProposalCategory category;
  final String title;
  final String authorName;
  final Vote? lastCastedVote;

  const VoteProposal({
    required this.ref,
    required this.category,
    required this.title,
    required this.authorName,
    this.lastCastedVote,
  });

  @override
  List<Object?> get props => [
        ref,
        category,
        title,
        authorName,
        lastCastedVote,
      ];
}

final class VoteProposalCategory extends Equatable {
  final DocumentRef ref;
  final String name;

  const VoteProposalCategory({
    required this.ref,
    required this.name,
  });

  @override
  List<Object?> get props => [
        ref,
        name,
      ];
}
