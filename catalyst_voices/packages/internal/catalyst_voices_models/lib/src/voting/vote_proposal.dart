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

  factory VoteProposal.fromData({
    required CoreProposal proposal,
    required CampaignCategory category,
    Vote? lastCastedVote,
  }) {
    final voteCategory = VoteProposalCategory.fromCampaignCategory(category);
    return VoteProposal(
      ref: proposal.id,
      category: voteCategory,
      title: proposal.title,
      authorName: proposal.author ?? '',
      lastCastedVote: lastCastedVote,
    );
  }

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

  factory VoteProposalCategory.fromCampaignCategory(CampaignCategory category) {
    return VoteProposalCategory(
      ref: category.id,
      name: category.formattedCategoryName,
    );
  }

  @override
  List<Object?> get props => [
    ref,
    name,
  ];
}
