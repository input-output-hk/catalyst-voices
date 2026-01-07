import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalBriefData extends Equatable {
  final DocumentRef id;
  final String authorName;
  final String title;
  final String description;
  final String categoryName;
  final int durationInMonths;
  final Money fundsRequested;
  final DateTime createdAt;
  final int iteration;
  final int? commentsCount;
  final bool isFinal;
  final bool isFavorite;
  final ProposalBriefDataVotes? votes;

  const ProposalBriefData({
    required this.id,
    required this.authorName,
    required this.title,
    required this.description,
    required this.categoryName,
    this.durationInMonths = 0,
    required this.fundsRequested,
    required this.createdAt,
    this.iteration = 1,
    this.commentsCount,
    this.isFinal = false,
    this.isFavorite = false,
    this.votes,
  });

  @override
  List<Object?> get props => [
    id,
    authorName,
    title,
    description,
    categoryName,
    durationInMonths,
    fundsRequested,
    createdAt,
    iteration,
    commentsCount,
    isFinal,
    isFavorite,
    votes,
  ];
}

final class ProposalBriefDataVotes extends Equatable {
  final Vote? draft;
  final Vote? casted;

  const ProposalBriefDataVotes({
    this.draft,
    this.casted,
  });

  @override
  List<Object?> get props => [draft, casted];
}
