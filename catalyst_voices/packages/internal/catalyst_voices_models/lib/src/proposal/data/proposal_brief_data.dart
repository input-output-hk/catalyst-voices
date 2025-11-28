import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalBriefData extends Equatable {
  final DocumentRef id;
  // TODO(damian-molinski): To be implemented
  final int fundNumber;
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
  // TODO(damian-molinski): To be implemented
  final List<ProposalBriefDataVersion>? versions;
  final List<ProposalBriefDataCollaborator>? collaborators;

  const ProposalBriefData({
    required this.id,
    required this.fundNumber,
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
    this.versions,
    this.collaborators,
  });

  @override
  List<Object?> get props => [
    id,
    fundNumber,
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
    versions,
    collaborators,
  ];
  DateTime get updateDate => id.ver?.dateTime ?? id.id.dateTime;
}

final class ProposalBriefDataCollaborator extends Equatable {
  final CatalystId id;
  final ProposalsCollaborationStatus status;

  const ProposalBriefDataCollaborator({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}

final class ProposalBriefDataVersion extends Equatable {
  final DocumentRef ref;
  final String? title;

  const ProposalBriefDataVersion({
    required this.ref,
    this.title,
  });

  @override
  List<Object?> get props => [ref, title];
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
