import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalBriefData extends Equatable {
  final DocumentRef id;
  final int fundNumber;
  final CatalystId? author;
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
  final List<ProposalBriefDataVersion>? versions;
  final List<ProposalBriefDataCollaborator>? collaborators;

  const ProposalBriefData({
    required this.id,
    required this.fundNumber,
    required this.author,
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

  factory ProposalBriefData.build({
    required RawProposalBrief data,
    required ProposalOrDocument proposal,
    Vote? draftVote,
    Vote? castedVote,
    Map<CatalystId, RawCollaboratorAction> collaboratorsActions = const {},
  }) {
    final id = data.proposal.id;
    final isFinal = data.isFinal;

    final versions = data.versionIds
        // TODO(damian-molinski): Get titles for all versions
        .map((e) => ProposalBriefDataVersion(ref: id.copyWith(ver: Optional(e))))
        .toList();

    // Proposal Brief do not support "removed" or "left" status.
    final collaborators = data.proposal.metadata.collaborators?.map(
      (id) {
        final action = collaboratorsActions[id.toSignificant()]?.action;
        final status = switch (action) {
          null => ProposalsCollaborationStatus.pending,
          ProposalSubmissionAction.aFinal => ProposalsCollaborationStatus.accepted,
          // When proposal is final draft action do not mean it's accepted
          ProposalSubmissionAction.draft when isFinal => ProposalsCollaborationStatus.pending,
          ProposalSubmissionAction.draft => ProposalsCollaborationStatus.accepted,
          ProposalSubmissionAction.hide => ProposalsCollaborationStatus.rejected,
        };

        return ProposalBriefDataCollaborator(
          id: id,
          status: status,
        );
      },
    ).toList();

    return ProposalBriefData(
      id: id,
      fundNumber: proposal.fundNumber ?? 0,
      author: data.originalAuthors.firstOrNull,
      title: proposal.title ?? '',
      description: proposal.description ?? '',
      categoryName: proposal.categoryName ?? '',
      durationInMonths: proposal.durationInMonths ?? 0,
      fundsRequested: proposal.fundsRequested ?? Money.zero(currency: Currencies.fallback),
      createdAt: id.ver!.dateTime,
      iteration: data.iteration,
      commentsCount: isFinal ? null : data.commentsCount,
      isFinal: isFinal,
      isFavorite: data.isFavorite,
      votes: isFinal ? ProposalBriefDataVotes(draft: draftVote, casted: castedVote) : null,
      versions: versions,
      collaborators: collaborators,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fundNumber,
    author,
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
