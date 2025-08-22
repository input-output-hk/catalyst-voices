import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class VotingListTileData extends Equatable {
  final DocumentRef category;
  final String categoryText;
  final List<VotingListTileVoteData> votes;

  const VotingListTileData({
    required this.category,
    required this.categoryText,
    required this.votes,
  });

  @override
  List<Object?> get props => [
    category,
    categoryText,
    votes,
  ];

  int get votesCount => votes.length;
}

final class VotingListTileVoteData extends Equatable {
  final DocumentRef proposal;
  final String proposalTitle;
  final String authorName;
  final VoteButtonData vote;

  const VotingListTileVoteData({
    required this.proposal,
    required this.proposalTitle,
    required this.authorName,
    required this.vote,
  });

  @override
  List<Object?> get props => [
    proposal,
    proposalTitle,
    authorName,
    vote,
  ];
}
