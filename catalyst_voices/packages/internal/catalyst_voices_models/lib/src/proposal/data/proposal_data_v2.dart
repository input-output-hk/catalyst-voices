import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalDataV2 extends Equatable {
  final DocumentRef id;

  /// The parsed proposal document with template schema.
  ///
  /// This is `null` when the template couldn't be retrieved.
  /// The UI should show an error message in this case.
  final ProposalDocument? document;
  final ProposalSubmissionAction? submissionAction;
  final bool isFavorite;
  final String categoryName;
  final ProposalBriefDataVotes? votes;
  final List<DocumentRef>? versions;
  final List<ProposalDataCollaborator>? collaborators;

  const ProposalDataV2({
    required this.id,
    required this.document,
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
  /// [proposal] - Provides extracted data (categoryName, etc.) from proposal.
  ///   Works both with and without template loaded.
  /// [proposalDocument] - Optional parsed proposal document. If null,
  ///   the UI should show an error that template couldn't be retrieved.
  ///   The caller (typically in the repository layer) should build this using
  ///   `ProposalDocumentFactory.create()` when `data.template` is available.
  factory ProposalDataV2.build({
    required RawProposal data,
    required ProposalOrDocument proposal,
    ProposalDocument? proposalDocument,
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
    );

    return ProposalDataV2(
      id: id,
      document: proposalDocument,
      submissionAction: action,
      isFavorite: data.isFavorite,
      categoryName: proposal.categoryName ?? '',
      collaborators: collaborators,
      versions: versions,
      votes: isFinal ? ProposalBriefDataVotes(draft: draftVote, casted: castedVote) : null,
    );
  }

  ProposalPublish? get proposalPublish {
    if (submissionAction == null && id is DraftRef) {
      return ProposalPublish.localDraft;
    } else if (submissionAction == ProposalSubmissionAction.aFinal) {
      return ProposalPublish.submittedProposal;
    } else if (submissionAction == ProposalSubmissionAction.draft) {
      return ProposalPublish.publishedDraft;
    }
    return null;
  }

  @override
  List<Object?> get props => [
    id,
    document,
    submissionAction,
    isFavorite,
    categoryName,
    votes,
    versions,
    collaborators,
  ];
}
