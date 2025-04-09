import 'dart:math';
import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/schema/document_schema_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/proposal/proposal_submission_action_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:rxdart/rxdart.dart';

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

// TODO(LynxLynxx): remove after implementing reading db
int _maxResults(ProposalPublish? stage) {
  if (stage == null) {
    return 64;
  }
  if (stage == ProposalPublish.submittedProposal) {
    return 48;
  }
  return 32;
}

abstract interface class ProposalRepository {
  const factory ProposalRepository(
    SignedDocumentManager signedDocumentManager,
    DocumentRepository documentRepository,
  ) = ProposalRepositoryImpl;

  Future<void> deleteDraftProposal(DraftRef ref);

  Future<Uint8List> encodeProposalForExport({
    required DocumentData document,
  });

  Future<ProposalData> getProposal({
    required DocumentRef ref,
  });

  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  });

  /// Fetches all proposals.
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  });

  /// Returns [ProposalTemplate] for matching [ref].
  ///
  /// Source of data depends whether [ref] is [SignedDocumentRef] or [DraftRef].
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  });

  Future<List<String>> getUserProposalsIds(String userId);

  Future<DocumentRef> importProposal(Uint8List data, CatalystId authorId);

  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  });

  Future<List<ProposalDocument>> queryVersionsOfId({
    required String id,
    bool includeLocalDrafts = false,
  });

  Future<void> upsertDraftProposal({required DocumentData document});

  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  });

  Stream<List<ProposalDocument>> watchLatestProposals({int? limit});

  /// Watches for [ProposalSubmissionAction] that were made on [refTo] document.
  ///
  /// As making action on document not always creates a new document ref
  /// we need to watch for actions on a document that has a reference to
  /// [refTo] document.
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  });

  Stream<List<ProposalDocument>> watchUserProposals({
    required CatalystId authorId,
  });
}

final class ProposalRepositoryImpl implements ProposalRepository {
  final SignedDocumentManager _signedDocumentManager;
  final DocumentRepository _documentRepository;

  const ProposalRepositoryImpl(
    this._signedDocumentManager,
    this._documentRepository,
  );

  @override
  Future<void> deleteDraftProposal(DraftRef ref) {
    return _documentRepository.deleteDocumentDraft(ref: ref);
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
  Future<ProposalData> getProposal({
    required DocumentRef ref,
  }) async {
    final documentData = await _documentRepository.getDocumentData(ref: ref);
    final commentsCount = await _documentRepository.getRefCount(
      ref: ref,
      type: DocumentType.commentDocument,
    );
    final proposalPublish = await getProposalPublishForRef(ref: ref);
    if (proposalPublish == null) {
      throw const NotFoundException(message: 'Proposal is hidden');
    }
    final templateRef = documentData.metadata.template!;
    final documentTemplate =
        await _documentRepository.getDocumentData(ref: templateRef);
    final proposalDocument = _buildProposalDocument(
      documentData: documentData,
      templateData: documentTemplate,
    );
    final documentVersions = await queryVersionsOfId(
      id: ref.id,
      includeLocalDrafts: true,
    );
    final proposalVersions = (await Future.wait(
      documentVersions.map(
        (e) async {
          final proposalPublish =
              await getProposalPublishForRef(ref: e.metadata.selfRef);

          if (proposalPublish == null) {
            return null;
          }
          return ProposalData(document: e, publish: proposalPublish);
        },
      ).toList(),
    ))
        .whereType<ProposalData>()
        .toList();

    return ProposalData(
      document: proposalDocument,
      commentsCount: commentsCount,
      versions: proposalVersions,
      publish: proposalPublish,
    );
  }

  @override
  Future<ProposalPublish?> getProposalPublishForRef({
    required DocumentRef ref,
  }) async {
    final data = await _documentRepository.getRefToDocumentData(
      refTo: ref,
      type: DocumentType.proposalActionDocument,
    );

    final action = _buildProposalActionData(data);
    return _getProposalPublish(ref: ref, action: action);
  }

  @override
  Future<ProposalsSearchResult> getProposals({
    required ProposalPaginationRequest request,
  }) async {
    // optionally filter by status.
    final proposals = <Proposal>[];

    // Return users proposals match his account id with proposals metadata from
    // author field.
    if (request.usersProposals) {
      return _getUserProposalsSearchResult(request);
    } else if (request.usersFavorite) {
      return _getFavoritesProposalsSearchResult(request);
    }

    for (var i = 0; i < request.pageSize; i++) {
      // ignore: lines_longer_than_80_chars
      final stage = Random().nextBool()
          ? ProposalPublish.submittedProposal
          : ProposalPublish.publishedDraft;
      proposals.add(
        Proposal(
          selfRef: SignedDocumentRef.generateFirstRef(),
          category: 'Cardano Use Cases / MVP',
          categoryId: const SignedDocumentRef(id: 'dummy_category_id'),
          title: 'Proposal Title that rocks the world',
          updateDate: DateTime.now().minusDays(2),
          fundsRequested: const Coin.fromWholeAda(100000),
          status: ProposalStatus.draft,
          publish: request.stage ?? stage,
          commentsCount: 0,
          description: _proposalDescription,
          duration: 6,
          author: 'Alex Wells',
          versions: const [],
        ),
      );
    }

    return ProposalsSearchResult(
      maxResults: _maxResults(request.stage),
      proposals: proposals,
    );
  }

  @override
  Future<ProposalTemplate> getProposalTemplate({
    required DocumentRef ref,
  }) async {
    final proposalDocument =
        await _documentRepository.getDocumentData(ref: ref);

    return _buildProposalTemplate(documentData: proposalDocument);
  }

  @override
  Future<List<String>> getUserProposalsIds(String userId) async {
    // TODO(LynxLynxx): read db to get user's proposals
    return <String>[];
  }

  @override
  Future<DocumentRef> importProposal(Uint8List data, CatalystId authorId) {
    return _documentRepository.importDocument(data: data, authorId: authorId);
  }

  @override
  Future<void> publishProposal({
    required DocumentData document,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(document.content.data),
      metadata: _createProposalMetadata(document.metadata),
      catalystId: catalystId,
      privateKey: privateKey,
    );

    await _documentRepository.publishDocument(document: signedDocument);
  }

  @override
  Future<void> publishProposalAction({
    required SignedDocumentRef actionRef,
    required SignedDocumentRef proposalRef,
    required SignedDocumentRef categoryId,
    required ProposalSubmissionAction action,
    required CatalystId catalystId,
    required CatalystPrivateKey privateKey,
  }) async {
    final dto = ProposalSubmissionActionDocumentDto(
      action: ProposalSubmissionActionDto.fromModel(action),
    );
    final signedDocument = await _signedDocumentManager.signDocument(
      SignedDocumentJsonPayload(dto.toJson()),
      metadata: SignedDocumentMetadata(
        contentType: SignedDocumentContentType.json,
        documentType: DocumentType.proposalActionDocument,
        id: actionRef.id,
        ver: actionRef.version,
        ref: SignedDocumentMetadataRef.fromDocumentRef(proposalRef),
        categoryId: SignedDocumentMetadataRef.fromDocumentRef(categoryId),
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
  Future<void> upsertDraftProposal({required DocumentData document}) {
    return _documentRepository.upsertDocument(document: document);
  }

  @override
  Stream<int> watchCount({
    required DocumentRef ref,
    required DocumentType type,
  }) {
    return _documentRepository.watchCount(ref: ref, type: type);
  }

  @override
  Stream<List<ProposalDocument>> watchLatestProposals({int? limit}) {
    return _documentRepository
        .watchDocuments(
          limit: limit,
          unique: true,
          type: DocumentType.proposalDocument,
        )
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

  @override
  Stream<ProposalPublish?> watchProposalPublish({
    required DocumentRef refTo,
  }) {
    return _documentRepository
        .watchRefToDocumentData(
      refTo: refTo,
      type: DocumentType.proposalActionDocument,
    )
        .map((data) {
      final action = _buildProposalActionData(data);

      return _getProposalPublish(ref: refTo, action: action);
    });
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

  ProposalSubmissionAction? _buildProposalActionData(
    DocumentData? action,
  ) {
    if (action == null) {
      return null;
    }
    final proposalAction = ProposalSubmissionActionDocumentDto.fromJson(
      action.content.data,
    ).action.toModel();

    return proposalAction;
  }

  ProposalDocument _buildProposalDocument({
    required DocumentData documentData,
    required DocumentData templateData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalDocument,
      'Not a proposalDocument document data type',
    );

    final template = _buildProposalTemplate(documentData: templateData);

    final metadata = ProposalMetadata(
      selfRef: documentData.metadata.selfRef,
      templateRef: documentData.metadata.template!,
      categoryId: documentData.metadata.categoryId!,
      authors: documentData.metadata.authors ?? [],
    );

    final content = DocumentDataContentDto.fromModel(
      documentData.content,
    );
    final schema = template.schema;
    final document = DocumentDto.fromJsonSchema(content, schema).toModel();

    return ProposalDocument(
      metadata: metadata,
      document: document,
    );
  }

  ProposalTemplate _buildProposalTemplate({
    required DocumentData documentData,
  }) {
    assert(
      documentData.metadata.type == DocumentType.proposalTemplate,
      'Not a proposalTemplate document data type',
    );

    final metadata = ProposalTemplateMetadata(
      selfRef: documentData.metadata.selfRef,
    );

    final contentData = documentData.content.data;
    final schema = DocumentSchemaDto.fromJson(contentData).toModel();

    return ProposalTemplate(
      metadata: metadata,
      schema: schema,
    );
  }

  SignedDocumentMetadata _createProposalMetadata(
    DocumentDataMetadata metadata,
  ) {
    final template = metadata.template;
    final categoryId = metadata.categoryId;

    return SignedDocumentMetadata(
      contentType: SignedDocumentContentType.json,
      documentType: DocumentType.proposalDocument,
      id: metadata.id,
      ver: metadata.version,
      template: template == null
          ? null
          : SignedDocumentMetadataRef.fromDocumentRef(template),
      categoryId: categoryId == null
          ? null
          : SignedDocumentMetadataRef.fromDocumentRef(categoryId),
    );
  }

  Future<ProposalsSearchResult> _getFavoritesProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final favoritesRefs = await _documentRepository
        .watchAllDocumentsFavoriteIds(type: DocumentType.proposalDocument)
        .map((event) => event.map((e) => SignedDocumentRef(id: e)).toList())
        .first;
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: favoritesRefs.length,
    );
    if (favoritesRefs.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final proposalData = await getProposal(ref: favoritesRefs[i]);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: favoritesRefs.length,
      proposals: proposals,
    );
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
        _ => ProposalPublish.publishedDraft,
      };
    }
  }

  Future<ProposalsSearchResult> _getUserProposalsSearchResult(
    ProposalPaginationRequest request,
  ) async {
    final userProposalsIds = await getUserProposalsIds('');
    final proposals = <Proposal>[];
    final range = PagingRange.calculateRange(
      pageKey: request.pageKey,
      itemsPerPage: request.pageSize,
      maxResults: userProposalsIds.length,
    );
    if (userProposalsIds.isEmpty) {
      return const ProposalsSearchResult(
        maxResults: 0,
        proposals: [],
      );
    }
    for (var i = range.from; i <= range.to; i++) {
      final ref = SignedDocumentRef(id: userProposalsIds[i]);
      final proposalData = await getProposal(ref: ref);
      final proposal = Proposal.fromData(proposalData);
      proposals.add(proposal);
    }

    return ProposalsSearchResult(
      maxResults: userProposalsIds.length,
      proposals: proposals,
    );
  }
}
