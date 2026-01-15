import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class ProposalDataV2 extends Equatable {
  final DocumentRef id;

  /// The parsed proposal document with template schema.
  ///
  /// This is `null` when the template couldn't be retrieved.
  /// The UI should show an error message in this case.
  final ProposalOrDocument proposalOrDocument;
  final ProposalSubmissionAction? submissionAction;
  final bool isFavorite;
  final String categoryName;
  final ProposalBriefDataVotes? votes;
  final List<DocumentRef>? versions;
  final List<ProposalDataCollaborator>? collaborators;

  const ProposalDataV2({
    required this.id,
    required this.proposalOrDocument,
    required this.submissionAction,
    required this.isFavorite,
    required this.categoryName,
    this.votes,
    this.versions,
    this.collaborators,
  });

  /// Builds a [ProposalDataV2] from raw data.
  ///
  /// [data] - Raw proposal data from database query.
  /// [proposalOrDocument] - Provides extracted data (categoryName, etc.) from proposal.
  ///   Works both with and without template loaded.
  factory ProposalDataV2.build({
    required RawProposal data,
    required ProposalOrDocument proposalOrDocument,
    Vote? draftVote,
    Vote? castedVote,
    Map<CatalystId, RawCollaboratorAction> collaboratorsActions = const {},
    List<CatalystId> prevCollaborators = const [],
    List<CatalystId> prevAuthors = const [],
    ProposalSubmissionAction? action,
  }) {
    final id = data.proposal.id;
    final isFinal = data.isFinal;

    final versions = data.versionIds.map((ver) => id.copyWith(ver: Optional(ver))).toList();

    final collaborators = ProposalDataCollaborator.resolveCollaboratorStatuses(
      isProposalFinal: isFinal,
      currentCollaborators: data.proposal.metadata.collaborators ?? [],
      collaboratorsActions: collaboratorsActions,
      prevCollaborators: prevCollaborators,
      prevAuthors: prevAuthors,
      createdAt: id.ver?.tryDateTime,
    );

    return ProposalDataV2(
      id: id,
      proposalOrDocument: proposalOrDocument,
      submissionAction: action,
      isFavorite: data.isFavorite,
      categoryName: proposalOrDocument.categoryName ?? '',
      collaborators: collaborators,
      versions: versions,
      votes: isFinal ? ProposalBriefDataVotes(draft: draftVote, casted: castedVote) : null,
    );
  }

  bool get isHidden => submissionAction == ProposalSubmissionAction.hide;

  @override
  List<Object?> get props => [
    id,
    proposalOrDocument,
    submissionAction,
    isFavorite,
    categoryName,
    votes,
    versions,
    collaborators,
  ];

  ProposalPublish get publish {
    return switch (id) {
      DraftRef() => ProposalPublish.localDraft,
      SignedDocumentRef() when submissionAction == ProposalSubmissionAction.aFinal =>
        ProposalPublish.submittedProposal,
      _ => ProposalPublish.publishedDraft,
    };
  }

  /// Adds missing versions from [other] proposal to this proposal.
  /// Returns a new [ProposalDataV2] with merged versions.
  ProposalDataV2 addMissingVersionsFrom(ProposalDataV2? other) {
    if (other?.versions == null || other!.versions!.isEmpty) {
      return this;
    }

    final currentVersions = versions ?? [];
    final otherVersions = other.versions!;

    final missingVersions = otherVersions
        .where(
          (otherVersion) => !currentVersions.any(
            (currentVersion) => currentVersion.id == otherVersion.id,
          ),
        )
        .toList();

    if (missingVersions.isEmpty) {
      return this;
    }

    final effectiveVersions = [...currentVersions, ...missingVersions]..sort();
    return copyWith(versions: effectiveVersions);
  }

  ProposalDataV2 copyWith({
    DocumentRef? id,
    ProposalOrDocument? proposalOrDocument,
    ProposalSubmissionAction? submissionAction,
    bool? isFavorite,
    String? categoryName,
    ProposalBriefDataVotes? votes,
    List<DocumentRef>? versions,
    List<ProposalDataCollaborator>? collaborators,
  }) {
    return ProposalDataV2(
      id: id ?? this.id,
      proposalOrDocument: proposalOrDocument ?? this.proposalOrDocument,
      submissionAction: submissionAction ?? this.submissionAction,
      isFavorite: isFavorite ?? this.isFavorite,
      categoryName: categoryName ?? this.categoryName,
      votes: votes ?? this.votes,
      versions: versions ?? this.versions,
      collaborators: collaborators ?? this.collaborators,
    );
  }
}
