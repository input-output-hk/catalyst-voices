import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalBriefData extends Equatable implements Comparable<ProposalBriefData> {
  final DocumentRef id;
  final int fundNumber;
  final CatalystId? author;
  final DocumentParameters parameters;
  final String? title;
  final String? description;
  final String? categoryName;
  final int? durationInMonths;
  final Money? fundsRequested;
  final DateTime createdAt;
  final int iteration;
  final int? commentsCount;
  final bool isFinal;
  final bool isFavorite;
  final ProposalBriefDataVotes? votes;
  final List<ProposalBriefDataVersion>? versions;
  final List<ProposalDataCollaborator>? collaborators;

  const ProposalBriefData({
    required this.id,
    this.fundNumber = 0,
    this.author,
    this.parameters = const DocumentParameters(),
    this.title,
    this.description,
    this.categoryName,
    this.durationInMonths,
    this.fundsRequested,
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
    VersionsTitles versionTitles = const VersionsTitles.empty(),
  }) {
    final id = data.proposal.id;
    final isFinal = data.isFinal;
    final iteration = versionTitles.verIteration(id.ver!);

    // Sort entries by version (oldest to newest) to assign correct version numbers
    final versionsList = versionTitles.data.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    final versions = versionsList.asMap().entries.map((mapEntry) {
      final index = mapEntry.key;
      final entry = mapEntry.value;
      return ProposalBriefDataVersion(
        ref: id.copyWith(ver: Optional(entry.key)),
        title: entry.value,
        versionNumber: index + 1,
      );
    }).toList(); // Stored oldest to newest

    // Proposal Brief do not support "removed" or "left" status.
    final collaborators = data.proposal.metadata.collaborators?.map(
      (id) {
        final rawCollaboratorAction = collaboratorsActions[id.toSignificant()];
        return ProposalDataCollaborator.fromAction(
          id: id,
          rawAction: rawCollaboratorAction,
          proposalId: data.proposal.id,
          isProposalFinal: isFinal,
        );
      },
    ).toList();

    return ProposalBriefData(
      id: id,
      fundNumber: proposal.fundNumber ?? 0,
      author: data.originalAuthors.firstOrNull,
      parameters: proposal.parameters,
      title: proposal.title,
      description: proposal.description,
      categoryName: proposal.categoryName,
      durationInMonths: proposal.durationInMonths,
      fundsRequested: proposal.fundsRequested,
      createdAt: id.ver!.dateTime,
      iteration: iteration,
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
    parameters,
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

  ProposalBriefData appendVersion({
    required DocumentRef ref,
    String? title,
  }) {
    final newVersionNumber = (versions?.length ?? 0) + 1;
    final version = ProposalBriefDataVersion(
      ref: ref,
      title: title,
      versionNumber: newVersionNumber,
    );

    // Keep versions sorted oldest to newest
    final updatedVersions = [...?versions, version]
      ..sort((a, b) => a.ref.ver!.compareTo(b.ref.ver!));

    return copyWith(versions: Optional(updatedVersions));
  }

  @override
  int compareTo(ProposalBriefData other) => createdAt.compareTo(other.createdAt);

  ProposalBriefData copyWith({
    DocumentRef? id,
    int? fundNumber,
    Optional<CatalystId>? author,
    DocumentParameters? parameters,
    Optional<String>? title,
    Optional<String>? description,
    Optional<String>? categoryName,
    Optional<int>? durationInMonths,
    Optional<Money>? fundsRequested,
    DateTime? createdAt,
    int? iteration,
    Optional<int>? commentsCount,
    bool? isFinal,
    bool? isFavorite,
    Optional<ProposalBriefDataVotes>? votes,
    Optional<List<ProposalBriefDataVersion>>? versions,
    Optional<List<ProposalDataCollaborator>>? collaborators,
  }) {
    return ProposalBriefData(
      id: id ?? this.id,
      fundNumber: fundNumber ?? this.fundNumber,
      author: author.dataOr(this.author),
      parameters: parameters ?? this.parameters,
      title: title.dataOr(this.title),
      description: description.dataOr(this.description),
      categoryName: categoryName.dataOr(this.categoryName),
      durationInMonths: durationInMonths.dataOr(this.durationInMonths),
      fundsRequested: fundsRequested.dataOr(this.fundsRequested),
      createdAt: createdAt ?? this.createdAt,
      iteration: iteration ?? this.iteration,
      commentsCount: commentsCount.dataOr(this.commentsCount),
      isFinal: isFinal ?? this.isFinal,
      isFavorite: isFavorite ?? this.isFavorite,
      votes: votes.dataOr(this.votes),
      versions: versions.dataOr(this.versions),
      collaborators: collaborators.dataOr(this.collaborators),
    );
  }

  int versionNumber(String version) {
    final versionsList = versions;
    if (versionsList == null) return 1;
    return versionsList.length - versionsList.indexWhere((element) => element.ref.ver == version);
  }
}

final class ProposalBriefDataVersion extends Equatable {
  final DocumentRef ref;
  final String? title;
  final int versionNumber;

  const ProposalBriefDataVersion({
    required this.ref,
    this.title,
    required this.versionNumber,
  });

  DateTime get createdAt => ref.ver!.dateTime;

  @override
  List<Object?> get props => [ref, title, versionNumber];
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
