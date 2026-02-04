import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/document/source/proposal_document_data_local_source.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_document_factory.dart';
import 'package:catalyst_voices_repositories/src/proposal/proposal_template_factory.dart';
import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';

typedef _ProposalDataComponents = (
  RawProposal? rawProposal,
  List<Vote> draftVotes,
  List<Vote> castedVotes,
);

/// Base interface to interact with proposals. A specialized version of [DocumentRepository] which
/// provides additional methods specific to proposals.
abstract interface class ProposalRepository {
  const factory ProposalRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
    DocumentDataRemoteSource documentRemoteSource,
    SignedDocumentDataSource documentLocalSource,
    ProposalDocumentDataLocalSource proposalsLocalSource,
    CastedVotesObserver castedVotesObserver,
    VotingBallotBuilder ballotBuilder,
  ) = ProposalRepositoryImpl;

  Future<void> deleteDraftProposal(DraftRef ref);

  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  });

  /// Similar to [watchLocalProposal] but returns single Future.
  Future<ProposalDataV2?> getLocalProposal({
    required DocumentRef id,
    required CatalystId originalAuthor,
  });

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  });

  /// Returns [ProposalTemplate] which belongs to [category].
  ///
  /// Returns null if no matching template is found.
  Future<ProposalTemplate?> getProposalTemplate({
    required DocumentRef category,
  });

  /// Similar to [watchProposal] but returns single Future.
  Future<ProposalDataV2?> getProposalV2({required DocumentRef id});

  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> publishProposalAction({
    required SignedDocumentRef actionId,
    required SignedDocumentRef proposalId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  Future<void> removeCollaboratorFromProposal({
    required SignedDocumentRef proposalId,
    required CatalystId collaboratorId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  });

  Future<void> upsertDraftProposal({required DocumentData document});

  Stream<int> watchCommentsCount({
    DocumentRef? referencing,
  });

  Stream<List<ProposalDocument>> watchLatestProposals({int? limit});

  /// Watches [author]'s list of local drafts (not published).
  ///
  /// This is simpler version of [watchProposalsBriefPage] since local drafts
  /// do not have actions or comments.
  Stream<List<ProposalBriefData>> watchLocalDraftProposalsBrief({
    required CatalystId author,
  });

  /// Watches the count of [author]'s local drafts (not published).
  Stream<int> watchLocalDraftProposalsCount({
    required CatalystId author,
  });

  Stream<ProposalDataV2?> watchLocalProposal({
    required DocumentRef id,
    required CatalystId originalAuthor,
  });

  /// Watches a single proposal by its reference.
  ///
  /// Returns a reactive stream that emits [ProposalDataV2] whenever the
  /// proposal data changes (document, actions, votes, favorites).
  ///
  /// Looks only for SignedDocumentRef
  ///
  /// Emits `null` if the proposal is not found.
  Stream<ProposalDataV2?> watchProposal({required DocumentRef id});

  /// Watches for [ProposalSubmissionAction] that were made on [referencing] document.
  ///
  /// As making action on document not always creates a new document ref
  /// we need to watch for actions on a document that has a reference to
  /// [referencing] document.
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef referencing,
  });

  /// Watches for a paginated list of published(not local) proposal briefs.
  ///
  /// This method provides a stream of [Page<ProposalBriefData>] that updates
  /// automatically when underlying data changes. It supports pagination through
  /// [request], ordering via [order], and filtering with [filters].
  ///
  /// The resulting [ProposalBriefData] objects are fully assembled, containing
  /// the proposal document, voting status (draft and casted), and collaborator
  /// actions.
  Stream<Page<ProposalBriefData>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order,
    ProposalsFiltersV2 filters,
  });

  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters,
  });

  Stream<List<ProposalTemplate>> watchProposalTemplates({
    required CampaignFilters campaign,
  });

  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;
  final DocumentDataRemoteSource _documentRemoteSource;
  final SignedDocumentDataSource _documentLocalSource;
  final ProposalDocumentDataLocalSource _proposalsLocalSource;
  final CastedVotesObserver _castedVotesObserver;
  final VotingBallotBuilder _ballotBuilder;

  const ProposalRepositoryImpl(
    this._signedDocumentManager,
    this._documentRepository,
    this._documentRemoteSource,
    this._documentLocalSource,
    this._proposalsLocalSource,
    this._castedVotesObserver,
    this._ballotBuilder,
  );

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(id: ref);
  }

  @override
  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  }) {
    return _documentRepository.encodeDocumentForExport(
      document: document,
    );
  }

  @override
  Future<ProposalDataV2?> getLocalProposal({
    required DocumentRef id,
    required CatalystId originalAuthor,
  }) {
    return _proposalsLocalSource
        .getLocalRawProposalData(id: id, originalAuthor: originalAuthor)
        .then((document) => _assembleProposalData((document, [], [])));
  }

  @override
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(id: ref);
    final commentsCount = await _documentRepository.getRefCount(
      referencing: ref,
      type: DocumentType.commentDocument,
    );
    final proposalPublish = await getProposalPublishForRef(ref: ref);
    if (proposalPublish == null) {
      throw DocumentHiddenException(ref: ref);
    }
    final templateRef = documentData.metadata.template!;
    final documentTemplate = await _documentRepository.getDocumentData(id: templateRef);
    final proposalDocument = _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );

    return ProposalData(
      document: proposalDocument,
      commentsCount: commentsCount,
      publish: proposalPublish,
    );
  }

  @override
  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  }) async {
    final data = await _documentRepository.getRefToDocumentData(
      referencing: ref,
      type: DocumentType.proposalActionDocument,
    );

    final action = _buildProposalActionData(data);
    return _getProposalPublish(ref: ref, action: action);
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef category,
  }) async {
    final documentData = await _documentRepository.findFirst(
      parameter: category,
      type: DocumentType.proposalTemplate,
    );

    if (documentData == null) {
      throw DocumentNotFoundException(
        ref: category,
        message: 'Proposal template with parameter not found',
      );
    }

    return ProposalTemplateFactory.create(documentData);
  }

  @override
  Future<ProposalDataV2?> getProposalV2({
    required DocumentRef id,
  }) async {
    final proposalData = await _proposalsLocalSource.getRawProposalData(id: id);

    final draftVotes = _ballotBuilder.votes;
    final castedVotes = _castedVotesObserver.votes;

    return _assembleProposalData((proposalData, draftVotes, castedVotes));
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: document.metadata,
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> publishProposalAction({
    required SignedDocumentRef actionId,
    required SignedDocumentRef proposalId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final dto = ProposalSubmissionActionDocumentDto(
      action: ProposalSubmissionActionDto.fromModel(action),
    );
    final documentMetadata = await _documentRepository.getDocumentMetadata(id: proposalId);
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(dto.toJson()),
      metadata: DocumentDataMetadata.proposalAction(
        id: actionId,
        proposalRef: proposalId,
        parameters: documentMetadata.parameters,
      ),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  }) async {
    final documents = await _documentRepository.queryVersionsOfId(
      id: id,
      includeLocalDrafts: includeLocalDrafts,
    );

    return documents
        .map(
          (e) => _buildProposalDocument(
            documentData: e.data,
            templateData: e.refData,
          ),
        )
        .toList();
  }

  @override
  Future<void> removeCollaboratorFromProposal({
    required SignedDocumentRef proposalId,
    required CatalystId collaboratorId,
    required CatalystPrivateKey privateKey,
  }) async {
    final artifact = await _documentRepository.getDocumentArtifact(id: proposalId);

    final updatedDocument = await _signedDocumentManager.signUpdatedDocument(
      artifact,
      buildMetadataUpdates: (metadata) {
        final updatedDocumentId = metadata.id.nextVersion();

        final updatedCollaborators = metadata.collaborators
            ?.whereNot((e) => e.isSameAs(collaboratorId))
            .toList();

        return DocumentDataMetadataUpdate(
          id: Optional(updatedDocumentId),
          collaborators: Optional(updatedCollaborators),
        );
      },
      catalystId: collaboratorId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: updatedDocument);
  }

  @override
  Future<void> updateProposalFavorite({
    required String id,
    required bool isFavorite,
  }) {
    return _proposalsLocalSource.updateProposalFavorite(id: id, isFavorite: isFavorite);
  }

  @override
  Future<void> upsertDraftProposal({required DocumentData document}) {
    return _documentRepository.upsertLocalDraftDocument(document: document);
  }

  @override
  Stream<int> watchCommentsCount({
    DocumentRef? referencing,
  }) {
    return _documentRepository.watchCount(
      referencing: referencing,
      type: DocumentType.commentDocument,
    );
  }

  @override
  Stream<List<ProposalDocument>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchDocuments(
          limit: limit,
          unique: true,
          type: DocumentType.proposalDocument,
        )
        .asyncMap(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
        );
  }

  @override
  Stream<List<ProposalBriefData>> watchLocalDraftProposalsBrief({
    required CatalystId author,
  }) {
    return _proposalsLocalSource
        .watchRawLocalDraftsProposalsBrief(author: author)
        .switchMap((proposals) => Stream.fromFuture(_assembleProposalBriefData(proposals)));
  }

  @override
  Stream<int> watchLocalDraftProposalsCount({
    required CatalystId author,
  }) {
    return _proposalsLocalSource.watchLocalDraftProposalsCount(author: author);
  }

  @override
  Stream<ProposalDataV2?> watchLocalProposal({
    required DocumentRef id,
    required CatalystId originalAuthor,
  }) {
    return _proposalsLocalSource
        .watchLocalRawProposalData(id: id, originalAuthor: originalAuthor)
        .switchMap((document) {
          return Stream.fromFuture(_assembleProposalData((document, [], [])));
        });
  }

  @override
  Stream<ProposalDataV2?> watchProposal({required DocumentRef id}) {
    // 1. The Data Stream - raw proposal from database
    final proposalStream = _proposalsLocalSource.watchRawProposalData(id: id);

    // 2. The Trigger Stream - watch action documents for collaborator updates
    final actionTrigger = _documentRepository.watchCount(
      type: DocumentType.proposalActionDocument,
    );

    // 3. Local ballot votes
    final draftVotes = _ballotBuilder.watchVotes;

    // 4. Casted votes stream
    final castedVotes = _castedVotesObserver.watchCastedVotes;

    // 5. Combine and assemble ProposalDataV2
    return Rx.combineLatest4(
      proposalStream,
      actionTrigger,
      draftVotes,
      castedVotes,
      (rawProposal, _, draftVotes, castedVotes) => (rawProposal, draftVotes, castedVotes),
    ).switchMap(
      (components) => Stream.fromFuture(_assembleProposalData(components)),
    );
  }

  @override
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef referencing,
  }) {
    return _documentRepository
        .watchRefToDocumentData(
          referencing: referencing,
          type: DocumentType.proposalActionDocument,
        )
        .map((data) {
          final action = _buildProposalActionData(data);

          return _getProposalPublish(ref: referencing, action: action);
        });
  }

  @override
  Stream<Page<ProposalBriefData>> watchProposalsBriefPage({
    required PageRequest request,
    ProposalsOrder order = const UpdateDate.desc(),
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    // 1. The Data Stream
    // This stream might not emit if only collaborator actions change
    // due to the distinct() in the DataSource.
    final pageStream = _adaptFilters(filters).switchMap(
      (effectiveFilters) {
        return _proposalsLocalSource.watchRawProposalsBriefPage(
          request: request,
          order: order,
          filters: effectiveFilters,
        );
      },
    );

    // 2. The Trigger Stream
    // We watch the count of Action documents. If a collaborator adds/updates
    // an action, this count (or the underlying table) changes, triggering an emission.
    // This forces the combineLatest to re-emit the (potentially stale) page,
    // allowing us to re-run the update of page.
    final actionTrigger = _documentRepository.watchCount(type: DocumentType.proposalActionDocument);

    // 3. Local ballot votes
    final draftVotes = _ballotBuilder.watchVotes;

    // 4. Casted votes stream.
    // If the votes becomes documents it should be moved somewhere in local docs source.
    final castedVotes = _castedVotesObserver.watchCastedVotes;

    // 5. Combine and page update
    return Rx.combineLatest4(
      pageStream,
      actionTrigger,
      draftVotes,
      castedVotes,
      (page, _, draftVotes, castedVotes) => (page, draftVotes, castedVotes),
    ).switchMap((components) {
      final page = components.$1;
      final draftVotes = Map.fromEntries(components.$2.map((e) => MapEntry(e.proposal, e)));
      final castedVotes = Map.fromEntries(components.$3.map((e) => MapEntry(e.proposal, e)));

      final briefs = _assembleProposalBriefData(
        page.items,
        draftVotes: draftVotes,
        castedVotes: castedVotes,
      ).then(page.copyWithItems);

      return Stream.fromFuture(briefs);
    });
  }

  @override
  Stream<int> watchProposalsCountV2({
    ProposalsFiltersV2 filters = const ProposalsFiltersV2(),
  }) {
    return _adaptFilters(filters).switchMap(
      (effectiveFilters) {
        return _proposalsLocalSource.watchProposalsCountV2(filters: effectiveFilters);
      },
    );
  }

  @override
  Stream<List<ProposalTemplate>> watchProposalTemplates({
    required CampaignFilters campaign,
  }) {
    return _proposalsLocalSource
        .watchProposalTemplates(campaign: campaign)
        .map((event) => event.map(ProposalTemplateFactory.create).toList());
  }

  @override
  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  }) {
    return _documentRepository
        .watchDocuments(
          type: DocumentType.proposalDocument,
          getLocalDrafts: true,
          unique: true,
          authorId: authorId,
        )
        .whereNotNull()
        .map(
          (documents) => documents.map(
            (doc) {
              final documentData = doc.data;
              final templateData = doc.refData;

              return _buildProposalDocument(
                documentData: documentData,
                templateData: templateData,
              );
            },
          ).toList(),
        );
  }

  // TODO(damian-molinski): Remove this when voteBy is implemented.
  Stream<ProposalsFiltersV2> _adaptFilters(ProposalsFiltersV2 filters) {
    if (filters.voteBy == null) {
      return Stream.value(filters);
    }

    return _castedVotesObserver.watchCastedVotes
        .map((votes) => votes.map((e) => e.proposal.id).toList())
        .map((ids) => filters.copyWith(voteBy: const Optional.empty(), ids: Optional(ids)));
  }

  Future<List<ProposalBriefData>> _assembleProposalBriefData(
    List<RawProposalBrief> rawProposals, {
    Map<DocumentRef, Vote> draftVotes = const {},
    Map<DocumentRef, Vote> castedVotes = const {},
  }) async {
    final proposalsRefs = rawProposals
        .where((element) => element.proposal.id.isSigned)
        // If proposal is final we have to get action for that exact version,
        // otherwise just latest action
        .map((e) => e.isFinal ? e.proposal.id : e.proposal.id.toLoose())
        .toList();

    final collaboratorsActions = await _proposalsLocalSource.getCollaboratorsActions(
      proposalsRefs: proposalsRefs,
    );

    // Fetch version titles for all proposals
    // TODO(bstolinski): get proposals titles based on template title noteId (dynamic nodeId)
    // group by template type, from template get nodeId. Exec getVersionsTitles for each template type
    // right now we have const nodeId ProposalDocument.titleNodeId
    final rawProposalsRefs = rawProposals.map((e) => e.proposal.id).toList();
    final rawProposalVersionsTitles = await _getProposalsVersionsTitles(rawProposalsRefs);

    return rawProposals.map((item) {
      final templateData = item.template;

      final proposalOrDocument = templateData == null
          ? ProposalOrDocument.data(item.proposal)
          : () {
              final template = ProposalTemplateFactory.create(templateData);
              final proposal = ProposalDocumentFactory.create(item.proposal, template: template);

              return ProposalOrDocument.proposal(proposal);
            }();

      final proposalId = item.proposal.id;

      final draftVote = draftVotes[proposalId];
      final castedVote = castedVotes[proposalId];
      final proposalCollaboratorsActions = collaboratorsActions[proposalId.id]?.data ?? const {};
      final versionTitles =
          rawProposalVersionsTitles.proposalVersions[proposalId.id] ?? const VersionsTitles.empty();

      return ProposalBriefData.build(
        data: item,
        proposal: proposalOrDocument,
        draftVote: draftVote,
        castedVote: castedVote,
        collaboratorsActions: proposalCollaboratorsActions,
        versionTitles: versionTitles,
      );
    }).toList();
  }

  Future<ProposalDataV2?> _assembleProposalData(
    _ProposalDataComponents components,
  ) async {
    var rawProposal = components.$1;

    if (rawProposal == null) {
      return null;
    }

    if (rawProposal.template == null && rawProposal.proposal.metadata.template != null) {
      final templateId = rawProposal.proposal.metadata.template!;
      final template = await _documentRemoteSource.get(templateId).onError((_, _) => null);
      if (template != null) {
        await _documentLocalSource.save(data: template);

        rawProposal = rawProposal.copyWith(template: Optional(template));
      }
    }

    final draftVotesMap = Map.fromEntries(components.$2.map((e) => MapEntry(e.proposal, e)));
    final castedVotesMap = Map.fromEntries(components.$3.map((e) => MapEntry(e.proposal, e)));

    final proposalData = rawProposal.proposal;
    final templateData = rawProposal.template;

    final proposalOrDocument = templateData == null
        ? ProposalOrDocument.data(proposalData)
        : () {
            final template = ProposalTemplateFactory.create(templateData);
            final proposal = ProposalDocumentFactory.create(
              proposalData,
              template: template,
            );
            return ProposalOrDocument.proposal(proposal);
          }();

    final proposalId = proposalData.id;
    final draftVote = draftVotesMap[proposalId];
    final castedVote = castedVotesMap[proposalId];

    final prevVersion = await _proposalsLocalSource.getPreviousOf(id: proposalId);

    DocumentDataMetadata? prevMetadata;
    if (prevVersion != null) {
      prevMetadata = await _documentRepository.getDocumentMetadata(id: prevVersion);
    }

    // if there is no previous authors then it can fallback to originalAuthors
    final prevAuthors = prevMetadata?.authors ?? rawProposal.originalAuthors;

    final actionsDocs = await _documentRepository.getProposalSubmissionActions(
      referencing: proposalId.toLoose(),
      authors: rawProposal.originalAuthors,
    );
    final action = _resolveProposalAction(actionDocs: actionsDocs, proposalId: proposalId);

    final collaboratorsActions = await _proposalsLocalSource.getCollaboratorsActions(
      proposalsRefs: [
        if (action != ProposalSubmissionAction.aFinal) proposalId.toLoose() else proposalId,
      ],
    );

    final proposalCollaboratorsActions = collaboratorsActions[proposalId.id]?.data ?? const {};

    return ProposalDataV2.build(
      data: rawProposal,
      proposalOrDocument: proposalOrDocument,
      draftVote: draftVote,
      castedVote: castedVote,
      collaboratorsActions: proposalCollaboratorsActions,
      prevCollaborators: prevMetadata?.collaborators ?? [],
      prevAuthors: prevAuthors,
      action: action,
    );
  }

  ProposalSubmissionAction? _buildProposalActionData(
    DocumentData? action,
  ) {
    if (action == null) {
      return null;
    }
    final dto = ProposalSubmissionActionDocumentDto.fromJson(action.content.data);
    return dto.action.toModel();
  }

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    final template = ProposalTemplateFactory.create(templateData);
    final proposal = ProposalDocumentFactory.create(documentData, template: template);
    return proposal;
  }

  ProposalPublish? _getProposalPublish({
    required DocumentRef ref,
    required ProposalSubmissionAction? action,
  }) {
    if (ref is DraftRef) {
      return ProposalPublish.localDraft;
    } else {
      return switch (action) {
        ProposalSubmissionAction.aFinal => ProposalPublish.submittedProposal,
        ProposalSubmissionAction.hide => null,
        ProposalSubmissionAction.draft || null => ProposalPublish.publishedDraft,
      };
    }
  }

  Future<ProposalVersionsTitles> _getProposalsVersionsTitles(List<DocumentRef> refs) async {
    final signedDocsIds = refs.where((ref) => ref.isSigned).map((e) => e.id).toSet().toList();
    final draftsDocsIds = refs.where((ref) => ref.isDraft).map((e) => e.id).toSet().toList();

    final signedDocsVersionsTitles = _proposalsLocalSource.getVersionsTitles(
      proposalIds: signedDocsIds,
      nodeId: ProposalDocument.titleNodeId,
    );

    final draftsDocsVersionsTitles = _proposalsLocalSource.getLocalDraftsVersionsTitles(
      proposalIds: draftsDocsIds,
      nodeId: ProposalDocument.titleNodeId,
    );

    return [
      signedDocsVersionsTitles,
      draftsDocsVersionsTitles,
    ].wait.then(ProposalVersionsTitles.fromList);
  }

  /// Resolves the effective action for a specific proposal version.
  ///
  /// [actionDocs] will be sorted from latest to oldest by version.
  /// [proposalId] is the specific proposal version to find the action for.
  ///
  /// Returns:
  /// - `ProposalSubmissionAction.hide` if the latest action is hide
  /// - The action for [proposalId] if it's not hide
  /// - Another non-hide action referencing [proposalId] if the matching action is hide but not latest
  /// - `null` if no suitable action is found
  ProposalSubmissionAction? _resolveProposalAction({
    required List<DocumentData> actionDocs,
    required DocumentRef proposalId,
  }) {
    if (actionDocs.isEmpty) return null;

    // Sort from latest to oldest by version
    final sortedDocs = actionDocs.sorted(
      (a, b) => b.metadata.id.compareTo(a.metadata.id),
    );

    final latestActionDoc = sortedDocs.first;
    final latestAction = _buildProposalActionData(latestActionDoc);

    // If latest action is hide, return hide
    if (latestAction == ProposalSubmissionAction.hide) {
      return ProposalSubmissionAction.hide;
    }

    // Find all actions referencing proposalRef
    final matchingDocs = sortedDocs.where(
      (doc) => doc.metadata.ref?.contains(proposalId) ?? false,
    );

    // Find a non-hide action for this proposal, or return null
    for (final doc in matchingDocs) {
      final action = _buildProposalActionData(doc);
      if (action != ProposalSubmissionAction.hide) {
        return action;
      }
    }

    return null;
  }
}
